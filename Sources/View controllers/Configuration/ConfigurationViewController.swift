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
  func configurationViewControllerDidTapShareButton(_ viewController: ConfigurationViewController)
}

class ConfigurationViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: ConfigurationViewControllerDelegate?

  lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  let cardTitle = UILabel()

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

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetTableViewContentBelowHeaderView()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.delegate?.configurationViewControllerDidClose(self)
  }

  private func insetTableViewContentBelowHeaderView() {
    let currentInset = self.tableView.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let newInset = UIEdgeInsets(top: headerHeight, left: currentInset.left, bottom: currentInset.bottom, right: currentInset.right)
      self.tableView.contentInset          = newInset
      self.tableView.scrollIndicatorInsets = newInset
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
    self.view.tintColor = Managers.theme.colors.tint.value
  }
}

// MARK: - UITableViewDelegate

extension ConfigurationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = self.tableViewDataSource.cellAt(indexPath)
    switch cell {
    case .personalization: self.delegate?.configurationViewControllerDidTapColorSelectionButton(self)
    case .contact:         Managers.app.openWebsite()
    case .share:           self.delegate?.configurationViewControllerDidTapShareButton(self)
    case .rate:            Managers.app.rateApp()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
