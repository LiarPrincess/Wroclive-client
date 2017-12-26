//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias CardPanel = BookmarksViewControllerConstants.CardPanel

class BookmarksViewController: UIViewController {

  // MARK: - Properties

  private let viewModel: BookmarksViewModel
  private let disposeBag = DisposeBag()

  lazy var headerView: UIVisualEffectView = {
    let headerViewBlur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: headerViewBlur)
  }()

  let titleLabel      = UILabel()
  let editButton      = UIButton()
  let tableView       = UITableView()
  let placeholderView = BookmarksPlaceholderView()

  // MARK: - Init

  init(_ viewModel: BookmarksViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initTableViewBindings()
    self.initVisibilityBindings()
    self.initEditBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initTableViewBindings() {
    let dataSource = self.createDataSource()

    self.viewModel.outputs.items
      .drive(self.tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    self.tableView.rx.itemSelected
      .bind(to: self.viewModel.inputs.itemSelected)
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemMoved
      .bind(to: self.viewModel.inputs.itemMoved)
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemDeleted
      .bind(to: self.viewModel.inputs.itemDeleted)
      .disposed(by: self.disposeBag)
  }

  private func createDataSource() -> RxTableViewDataSource<BookmarksSection> {
    return RxTableViewDataSource(
      configureCell: { _, tableView, index, model -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(ofType: BookmarkCell.self, forIndexPath: index)
        cell.viewModel.inputs.bookmark.onNext(model)
        return cell
      },
      canEditRowAtIndexPath: { _, _ in true },
      canMoveRowAtIndexPath: { _, _ in true }
    )
  }

  private func initVisibilityBindings() {
    self.viewModel.outputs.isTableViewVisible
      .drive(self.tableView.rx.isVisible)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.isTableViewVisible
      .drive(self.editButton.rx.isVisible)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.isPlaceholderVisible
      .drive(self.placeholderView.rx.isVisible)
      .disposed(by: self.disposeBag)
  }

  private func initEditBindings() {
    self.editButton.rx.tap
      .bind(to: self.viewModel.inputs.editButtonPressed)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.isEditing
      .drive(onNext: { [weak self] in self?.setEditing($0, animated: true) })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.editButtonText
      .drive(self.editButton.rx.attributedTitle())
      .disposed(by: self.disposeBag)
  }

  // MARK: - Override

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

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    if editing { self.closeSwipeToDelete() }
    self.tableView.setEditing(editing, animated: true)
  }

  private func closeSwipeToDelete() {
    let hasSwipeToDeleteOpen = self.tableView.isEditing
    if hasSwipeToDeleteOpen {
      self.tableView.setEditing(false, animated: false)
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.viewModel.inputs.viewDidDisappear.onNext(())
  }
}

// MARK: - CardPanelPresentable

extension BookmarksViewController: CardPanelPresentable {
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return CardPanel.height }
}
