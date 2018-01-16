//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias CardPanel = SettingsCardConstants.CardPanel

class SettingsCard: UIViewController {

  // MARK: - Properties

//  private let viewModel: BookmarksCardViewModel
//  private let disposeBag = DisposeBag()

  lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  let titleLabel = UILabel()

  let tableView           = UITableView(frame: .zero, style: .grouped)
  let tableViewDataSource = ConfigurationDataSource()

  // MARK: - Init

//  convenience init() { // _ viewModel: BookmarksCardViewModel
//    self.init(nibName: nil, bundle: nil)
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetTableViewContentBelowHeaderView()
  }

  private func insetTableViewContentBelowHeaderView() {
    let currentInset = self.tableView.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let newInset = UIEdgeInsets(top: headerHeight, left: currentInset.left, bottom: currentInset.bottom, right: currentInset.right)
      self.tableView.contentInset          = newInset
      self.tableView.scrollIndicatorInsets = newInset

      // scroll up to preserve current scroll position
//      let currentOffset = self.tableView.contentOffset
//      let newOffset     = CGPoint(x: currentOffset.x, y: currentOffset.y + currentInset.top - headerHeight)
//      self.tableView.setContentOffset(newOffset, animated: false)
    }
  }
}

// MARK: - CardPanelPresentable

extension SettingsCard: CardPanelPresentable {
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return CardPanel.height }
}

// MARK: - UITableViewDelegate

extension SettingsCard: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let cell = self.tableViewDataSource.cellAt(indexPath)
//    switch cell {
//    case .personalization: self.delegate?.configurationViewControllerDidTapColorSelectionButton(self)
//    case .contact:         Managers.app.openWebsite()
//    case .share:           self.delegate?.configurationViewControllerDidTapShareButton(self)
//    case .rate:            Managers.app.rateApp()
//    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
