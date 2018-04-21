//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

private typealias Layout       = SettingsCardConstants.Layout
private typealias TextStyles   = SettingsCardConstants.TextStyles
private typealias Localization = Localizable.Settings

class SettingsCard: CardPanel {

  // MARK: - Properties

  private let viewModel: SettingsCardViewModelType
  private let disposeBag = DisposeBag()

  lazy var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  let titleLabel = UILabel()

  lazy var tableView            = UITableView(frame: .zero, style: .grouped)
  lazy var tableViewDataSource  = SettingsCard.createDataSource(self)

  // MARK: - Card panel

  override var height:     CGFloat       { return Layout.height  }
  override var scrollView: UIScrollView? { return self.tableView }

  // MARK: - Init

  init(_ viewModel: SettingsCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initTableViewBindings()
    self.initCellButtonsBindings()
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

  private func initCellButtonsBindings() {
    self.viewModel.outputs.showShareControl
      .drive(onNext: { [unowned self] _ in self.showShareActivity() })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showRateControl
      .drive(onNext: { [unowned self] _ in self.rateApp() })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showAboutPage
      .drive(onNext: { [unowned self] _ in self.showAboutPage() })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Data source

  private static func createDataSource(_ card: SettingsCard) -> RxTableViewDataSource<SettingsSection> {
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

  // MARK: - Buttons

  func rateApp() {
    UIApplication.shared.open(Managers.variables.appStore.writeReviewUrl)
  }

  func showShareActivity() {
    let url   = Managers.variables.appStore.shareUrl
    let text  = String(format: Localizable.Share.message, url.absoluteString)
    let image = Assets.shareImage
    let items = [text, image] as [Any]

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.excludedActivityTypes  = [.assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .openInIBooks, .print]
    activityViewController.modalPresentationStyle = .overCurrentContext
    self.present(activityViewController, animated: true, completion: nil)
  }

  func showAboutPage() {
    let safariViewController = SFSafariViewController(url: Managers.variables.websiteUrl)
    safariViewController.modalPresentationStyle = .overFullScreen
    self.present(safariViewController, animated: true, completion: nil)
  }
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
