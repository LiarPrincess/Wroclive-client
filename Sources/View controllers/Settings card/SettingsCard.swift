//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias TextStyles   = SettingsCardConstants.TextStyles
private typealias CardPanel    = SettingsCardConstants.CardPanel
private typealias Localization = Localizable.Configuration

class SettingsCard: UIViewController {

  // MARK: - Properties

  private let viewModel: SettingsCardViewModel
  private let disposeBag = DisposeBag()

  lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  let titleLabel = UILabel()

  let tableView           = UITableView(frame: .zero, style: .grouped)
  let tableViewDataSource = SettingsCard.createDataSource()

  // MARK: - Init

  init(_ viewModel: SettingsCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initTableViewBindings()
    self.initViewControlerLifecycleBindings()
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

    self.tableView.rx.itemSelected
      .do(onNext: { [weak self] in self?.tableView.deselectRow(at: $0, animated: true) })
      .bind(to: self.viewModel.inputs.itemSelected)
      .disposed(by: self.disposeBag)
  }

  private func initViewControlerLifecycleBindings() {
    self.viewModel.outputs.shouldClose
      .drive(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Data source

  private static func createDataSource() -> RxTableViewDataSource<SettingsSection> {
    return RxTableViewDataSource(
      configureCell: { _, tableView, indexPath, model -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(ofType: UITableViewCell.self, forIndexPath: indexPath)
        cell.textLabel?.attributedText = NSAttributedString(string: createCellText(model), attributes: TextStyles.cellText)
        cell.backgroundColor           = Managers.theme.colors.background
        cell.accessoryType             = .disclosureIndicator
        return cell
      },
      canEditRowAtIndexPath: { _, _ in false },
      canMoveRowAtIndexPath: { _, _ in false }
    )
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
    }
  }
}

// MARK: - CardPanelPresentable

extension SettingsCard: CardPanelPresentable {
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return CardPanel.height }
}

// MARK: - UITableViewDelegate

extension SettingsCard: UITableViewDelegate { }

// MARK: - Helpers

private func createCellText(_ cellType: SettingsCellType) -> String {
  switch cellType {
  case .mapType: return Localization.Cell.colors
  case .about:   return Localization.Cell.contact
  case .share:   return Localization.Cell.share
  case .rate:    return Localization.Cell.rate
  }
}
