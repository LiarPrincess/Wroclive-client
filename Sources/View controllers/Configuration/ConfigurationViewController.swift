//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Layout = ConfigurationViewControllerConstants.Layout

class ConfigurationViewController: UIViewController {

  // MARK: - Properties

  let headerViewBlur = UIBlurEffect(style: Managers.theme.colorScheme.blurStyle)

  lazy var headerView: UIVisualEffectView = {
    return UIVisualEffectView(effect: self.headerViewBlur)
  }()

  let chevronView = ChevronView()
  let cardTitle   = UILabel()

  let scrollView        = UIScrollView()
  let scrollViewContent = UIView()

  let inAppPurchasePresentation = InAppPurchasePresentation()

  let configurationTable = IntrinsicTableView(frame: .zero, style: .grouped)
  let colorsCell   = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let shareCell    = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let tutorialCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let contactCell  = UITableViewCell(style: .value1, reuseIdentifier: nil)
  let rateCell     = UITableViewCell(style: .value1, reuseIdentifier: nil)

  var viewSize: CGFloat {
    let relativeHeight = MainViewControllerConstants.CardPanel.configurationRelativeHeight
    return relativeHeight * UIScreen.main.bounds.height
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
        let offset = strongSelf.viewSize * Layout.Content.initialScrollPercent
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
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.headerView }

  func dismissalTransitionWillBegin() {
    self.chevronView.setState(.flat, animated: true)
  }

  func dismissalTransitionDidEnd(_ completed: Bool) {
    if !completed {
      self.chevronView.setState(.down, animated: true)
    }
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
    switch (indexPath.section, indexPath.row) {
    case (0, 0): self.showThemeManager()
    case (1, 0): Managers.app.showShareActivity(in: self)
    case (1, 1): self.showTutorial()
    case (1, 2): Managers.app.openWebsite()
    case (1, 3): Managers.appStore.rateApp()
    default: fatalError("Unexpected row")
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  private func showThemeManager() {
    let viewController = ColorSelectionViewController()
    viewController.modalPresentationStyle = .custom
    self.present(viewController, animated: true, completion: nil)
  }

  private func showTutorial() {
    let viewController = TutorialPresentation()
    viewController.modalPresentationStyle = .custom
    self.present(viewController, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource

extension ConfigurationViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 1
    case 1: return 4
    default: fatalError("Unexpected section")
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
    case (0, 0): return self.colorsCell
    case (1, 0): return self.shareCell
    case (1, 1): return self.tutorialCell
    case (1, 2): return self.contactCell
    case (1, 3): return self.rateCell
    default: fatalError("Unexpected (section, row)")
    }
  }
}
