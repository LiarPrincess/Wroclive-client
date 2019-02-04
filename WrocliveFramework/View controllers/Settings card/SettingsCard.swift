// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa
import SafariServices

private typealias Layout       = SettingsCardConstants.Layout
private typealias TextStyles   = SettingsCardConstants.TextStyles
private typealias Localization = Localizable.Settings

public final class SettingsCard: UIViewController, CustomCardPanelPresentable, ChevronViewOwner {

  // MARK: - Properties

  private let viewModel: SettingsCardViewModel
  private let disposeBag = DisposeBag()

  public lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  public let chevronView = ChevronView()
  public let titleLabel  = UILabel()

  public let tableView            = UITableView(frame: .zero, style: .grouped)
  public let tableViewDataSource  = SettingsCard.createDataSource()

  // MARK: - Init

  public init(_ viewModel: SettingsCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initTableViewBindings()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initTableViewBindings() {
    self.tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    self.viewModel.items
      .drive(self.tableView.rx.items(dataSource: self.tableViewDataSource))
      .disposed(by: disposeBag)

    self.tableView.rx.itemSelected
      .do(onNext: { [weak self] in self?.tableView.deselectRow(at: $0, animated: true) })
      .bind(to: self.viewModel.didSelectItem)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Data source

  private static func createDataSource() -> RxTableViewDataSource<SettingsSection> {
    return RxTableViewDataSource(
      configureCell: { dataSource, tableView, indexPath, model -> UITableViewCell in
        switch model {
        case .share, .rate, .about:
          let lastItemIndex = dataSource.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1

          let cell = tableView.dequeueCell(ofType: SettingsTextCell.self, forIndexPath: indexPath)
          cell.textLabel?.attributedText = NSAttributedString(string: model.text, attributes: TextStyles.cellText)
          cell.accessoryType             = .disclosureIndicator
          cell.isBottomBorderVisible     = indexPath.item != lastItemIndex
          return cell
        }
      },
      canEditRowAtIndexPath: { _, _ in false },
      canMoveRowAtIndexPath: { _, _ in false }
    )
  }

  // MARK: - Override

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  public override func viewDidLayoutSubviews() {
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
      let currentOffset = self.tableView.contentOffset
      let newOffset     = CGPoint(x: currentOffset.x, y: currentOffset.y + currentInset.top - headerHeight)
      self.tableView.setContentOffset(newOffset, animated: false)
    }
  }

  // MARK: - CustomCardPanelPresentable

  public var scrollView: UIScrollView? {
    return self.tableView
  }

  public func interactiveDismissalProgress(percent: CGFloat) {
    self.updateChevronViewDuringInteractiveDismissal(percent: percent)
  }

  public func interactiveDismissalDidEnd(completed: Bool) {
    self.updateChevronViewAfterInteractiveDismissal()
  }
}

// MARK: - UITableViewDelegate

extension SettingsCard: UITableViewDelegate {

  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    typealias HeaderLayout = SettingsSectionHeaderViewConstants.Layout

    let width  = tableView.bounds.width - HeaderLayout.leftInset - HeaderLayout.rightInset
    let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)

    let sectionType = self.tableViewDataSource[section].model
    let text        = NSAttributedString(string: sectionType.text, attributes: TextStyles.sectionTitle)
    let textSize    = text.boundingRect(with: bounds, options: .usesLineFragmentOrigin, context: nil)

    return textSize.height + HeaderLayout.topInset + HeaderLayout.bottomInset + 1.0
  }

  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1
  }

  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionType = self.tableViewDataSource[section].model

    let view = tableView.dequeueSupplementary(ofType: SettingsSectionHeaderView.self)
    view.titleLabel.attributedText = NSAttributedString(string: sectionType.text, attributes: TextStyles.sectionTitle)
    return view
  }
}
