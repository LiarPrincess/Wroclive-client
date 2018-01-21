//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias TextStyles   = SettingsCardConstants.TextStyles
private typealias CardPanel    = SettingsCardConstants.CardPanel
private typealias Localization = Localizable.Settings

class SettingsCard: UIViewController {

  // MARK: - Properties

  private let viewModel: SettingsCardViewModel
  private let disposeBag = DisposeBag()

  lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  let titleLabel = UILabel()

  let tableView            = UITableView(frame: .zero, style: .grouped)
  let tableViewMapTypeCell = SettingsMapTypeCell(style: .default, reuseIdentifier: nil)

  lazy var tableViewDataSource: RxTableViewDataSource<SettingsSection> = {
    return RxTableViewDataSource( // swiftlint:disable:this implicit_return
      configureCell: { [unowned self] dataSource, tableView, indexPath, model -> UITableViewCell in
        switch model {
        case .mapType:
          return self.tableViewMapTypeCell
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
  }()

  // MARK: - Init

  init(_ viewModel: SettingsCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initTableViewBindings()
    self.initCellOperationsBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initTableViewBindings() {
    self.tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    self.viewModel.outputs.items
      .drive(self.tableView.rx.items(dataSource: self.tableViewDataSource))
      .disposed(by: disposeBag)

    self.tableViewMapTypeCell.rx.selectedValueChanged
      .bind(to: self.viewModel.inputs.mapTypeSelected)
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemSelected
      .do(onNext: { [weak self] in self?.tableView.deselectRow(at: $0, animated: true) })
      .bind(to: self.viewModel.inputs.itemSelected)
      .disposed(by: self.disposeBag)
  }

  private func initCellOperationsBindings() {
    self.viewModel.outputs.showShareControl
      .drive(onNext: { [unowned self] _ in SearchCardOperations.showShareActivity(in: self) })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showRateControl
      .drive(onNext: { _ in SearchCardOperations.rateApp() })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showAboutPage
      .drive(onNext: { [unowned self] _ in SearchCardOperations.showAboutPage(in: self) })
      .disposed(by: self.disposeBag)
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
}

// MARK: - CardPanelPresentable

extension SettingsCard: CardPanelPresentable {
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return CardPanel.height }
}

// MARK: - UITableViewDelegate

extension SettingsCard: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    typealias HeaderLayout = SettingsSectionHeaderViewConstants.Layout

    let width  = tableView.bounds.width - HeaderLayout.leftInset - HeaderLayout.rightInset
    let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)

    let sectionType = self.tableViewDataSource[section].model
    let text        = NSAttributedString(string: sectionType.text, attributes: TextStyles.sectionTitle)
    let textSize    = text.boundingRect(with: bounds, options: .usesLineFragmentOrigin, context: nil)

    return textSize.height + HeaderLayout.topInset + HeaderLayout.bottomInset + 1.0
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionType = self.tableViewDataSource[section].model

    let view = tableView.dequeueSupplementary(ofType: SettingsSectionHeaderView.self)
    view.titleLabel.attributedText = NSAttributedString(string: sectionType.text, attributes: TextStyles.sectionTitle)
    return view
  }
}
