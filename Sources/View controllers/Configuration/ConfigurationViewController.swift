//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = ConfigurationViewControllerConstants
private typealias Layout    = ConfigurationViewControllerConstants.Layout

class ConfigurationViewController: UIViewController {

  // MARK: - Properties

  lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Managers.theme.colorScheme.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  let cardTitle = UILabel()

  let scrollView        = UIScrollView()
  let scrollViewContent = UIView()

  let inAppPurchasePresentation = InAppPurchasePresentation()

  let tableView           = IntrinsicTableView(frame: .zero, style: .grouped)
  let tableViewDataSource = ConfigurationDataSource()

  var pushTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  // MARK: - Init

  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.startObservingColorScheme()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.stopObservingColorScheme()
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  private var isAppearingForFirstTime = true

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if self.isAppearingForFirstTime {
      self.offsetScrolViewToInitialPosition()
      self.isAppearingForFirstTime = false
    }
  }

  // MARK: - Scroll view

  func offsetScrolViewToInitialPosition() {
    DispatchQueue.main.async { [weak self] in
      if let strongSelf = self {
        let offset = strongSelf.height * Layout.Content.initialScrollPercent
        strongSelf.scrollView.contentOffset = CGPoint(x: 0.0, y: offset)
      }
    }
  }

  func updateScrollViewBackgroundColor() {
    let gradientColor = PresentationControllerConstants.Colors.Gradient.colors.first
    let tableColor    = Managers.theme.colorScheme.configurationBackground

    let scrollPosition  = scrollView.contentOffset.y
    let backgroundColor = scrollPosition <= 0.0 ? gradientColor : tableColor

    if let backgroundColor = backgroundColor, self.scrollView.backgroundColor != backgroundColor {
      self.scrollView.backgroundColor = backgroundColor
    }
  }
}

// MARK: - CardPanelPresentable

extension ConfigurationViewController: CardPanelPresentable {
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return Constants.CardPanel.relativeHeight * screenHeight}
}

// MARK: - ColorSchemeObserver

extension ConfigurationViewController: ColorSchemeObserver {
  func colorSchemeDidChange() {
    self.view.tintColor = Managers.theme.colorScheme.tintColor.value
  }
}

// MARK: - UIScrollViewDelegate

extension ConfigurationViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.updateScrollViewBackgroundColor()
  }
}

// MARK: - UITableViewDelegate

extension ConfigurationViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = self.tableViewDataSource.cellAt(indexPath)
    switch cell {
    case .personalization: self.showThemeManager()
    case .tutorial:        self.showTutorial()
    case .contact:         Managers.app.openWebsite()
    case .share:           Managers.app.showShareActivity(in: self)
    case .rate:            Managers.appStore.rateApp()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  private func showThemeManager() {
    let controller = ColorSelectionViewController()
    self.present(controller)
  }

  private func showTutorial() {
    let controller = TutorialViewController(mode: .default)
    self.present(controller)
  }

  private func present(_ controller: UIViewController) {
    self.pushTransitionDelegate = PushTransitionDelegate(for: controller)
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate  = self.pushTransitionDelegate
    self.present(controller, animated: true, completion: nil)
  }
}
