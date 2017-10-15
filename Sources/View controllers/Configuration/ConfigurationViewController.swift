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

class ConfigurationViewController: UIViewController, HasThemeManager {

  typealias Dependencies = HasAppManager & HasAppStoreManager & HasThemeManager & HasNotificationManager

  // MARK: - Properties

  let managers: Dependencies
  var theme: ThemeManager { return self.managers.theme }

  weak var delegate: ConfigurationViewControllerDelegate?

  lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: self.theme.colorScheme.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  let cardTitle = UILabel()

  let scrollView        = UIScrollView()
  let scrollViewContent = UIView()

  lazy var inAppPurchasePresentation = {
    return InAppPurchasePresentation(managers: self.managers)
  }()

  let tableView           = IntrinsicTableView(frame: .zero, style: .grouped)
  let tableViewDataSource = ConfigurationDataSource()

  // MARK: - Init

  convenience init(managers: Dependencies, delegate: ConfigurationViewControllerDelegate? = nil) {
    self.init(nibName: nil, bundle: nil, managers: managers, delegate: delegate)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, managers: Dependencies, delegate: ConfigurationViewControllerDelegate? = nil) {
    self.managers = managers
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
    let gradientColor = self.theme.colorScheme.presentation.gradient.first
    let tableColor    = self.theme.colorScheme.configurationBackground

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

extension ConfigurationViewController: ColorSchemeObserver, HasNotificationManager {

  var notification: NotificationManager { return self.managers.notification }

  func colorSchemeDidChange() {
    self.view.tintColor = self.theme.colorScheme.tintColor.value
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
    case .contact:         self.managers.app.openWebsite()
    case .share:           self.managers.app.showShareActivity(in: self)
    case .rate:            self.managers.appstore.rateApp()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
