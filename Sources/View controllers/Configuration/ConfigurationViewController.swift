//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = ConfigurationViewControllerConstants
private typealias Layout    = ConfigurationViewControllerConstants.Layout

protocol ConfigurationViewControllerDelegate: class {
  func configurationViewControllerDidClose(_ viewController: ConfigurationViewController)

  func configurationViewControllerDidTapColorSelectionButton(_ viewController: ConfigurationViewController)
  func configurationViewControllerDidTapTutorialButton(_ viewController: ConfigurationViewController)
}

class ConfigurationViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: ConfigurationViewControllerDelegate?

  lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  let cardTitle = UILabel()

  let scrollView        = UIScrollView()
  let scrollViewContent = UIView()

  lazy var inAppPurchasePresentation = InAppPurchasePresentation()

  let tableView           = IntrinsicTableView(frame: .zero, style: .grouped)
  let tableViewDataSource = ConfigurationDataSource()

  // MARK: - Init

  convenience init(delegate: ConfigurationViewControllerDelegate? = nil) {
    self.init(nibName: nil, bundle: nil, delegate: delegate)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: ConfigurationViewControllerDelegate? = nil) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.delegate = delegate
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

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.delegate?.configurationViewControllerDidClose(self)
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
    let gradientColor = Managers.theme.colors.presentation.gradient.first
    let tableColor    = Managers.theme.colors.configurationBackground

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
    self.view.tintColor = Managers.theme.colors.tintColor.value
  }
}

// MARK: - UIScrollViewDelegate

extension ConfigurationViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView == self.scrollView else { return }
    self.updateScrollViewBackgroundColor()
  }
}

// MARK: - UITableViewDelegate

extension ConfigurationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = self.tableViewDataSource.cellAt(indexPath)
    switch cell {
    case .personalization: self.delegate?.configurationViewControllerDidTapColorSelectionButton(self)
    case .tutorial:        self.delegate?.configurationViewControllerDidTapTutorialButton(self)
    case .contact:         Managers.app.openWebsite()
    case .share:           Managers.app.showShareActivity(in: self)
    case .rate:            Managers.appStore.rateApp()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
