// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

private typealias Layout = BookmarksCardConstants.Layout
typealias BookmarksSection = RxSectionModel<String, Bookmark>

class BookmarksCard: CardPanel {

  // MARK: - Properties

  var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  let titleLabel      = UILabel()
  let editButton      = UIButton()
  let placeholderView = BookmarksPlaceholderView()

  let tableView           = UITableView()
  let tableViewDataSource = BookmarksCard.createDataSource()

  private let viewModel: BookmarksCardViewModel
  private let disposeBag = DisposeBag()

  // MARK: - Card panel

  override var height:     CGFloat       { return Layout.height }
  override var scrollView: UIScrollView? { return self.tableView }

  // MARK: - Init

  init(_ viewModel: BookmarksCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initTableViewBindings()
    self.initVisibilityBindings()
    self.initEditBindings()
    self.initCloseBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initTableViewBindings() {
    self.tableView.rx.setDelegate(self)
      .disposed(by: self.disposeBag)

    self.viewModel.bookmarks
      .map { [BookmarksSection(model: .empty, items: $0)] }
      .drive(self.tableView.rx.items(dataSource: self.tableViewDataSource))
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemSelected
      .map { $0.row }
      .bind(to: self.viewModel.didSelectItem)
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemMoved
      .map { source, destination in (source.row, destination.row) }
      .bind(to: self.viewModel.didMoveItem)
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemDeleted
      .map { $0.row }
      .bind(to: self.viewModel.didDeleteItem)
      .disposed(by: self.disposeBag)
  }

  private func initVisibilityBindings() {
    self.viewModel.isTableViewVisible
      .drive(self.tableView.rx.isVisible)
      .disposed(by: self.disposeBag)

    self.viewModel.isTableViewVisible
      .drive(self.editButton.rx.isVisible)
      .disposed(by: self.disposeBag)

    self.viewModel.isPlaceholderVisible
      .drive(self.placeholderView.rx.isVisible)
      .disposed(by: self.disposeBag)
  }

  private func initEditBindings() {
    self.editButton.rx.tap
      .bind(to: self.viewModel.didPressEditButton)
      .disposed(by: self.disposeBag)

    self.viewModel.isEditing
      .drive(onNext: { [weak self] in self?.setEditing($0, animated: true) })
      .disposed(by: self.disposeBag)

    self.viewModel.editButtonText
      .drive(self.editButton.rx.attributedTitle())
      .disposed(by: self.disposeBag)
  }

  private func initCloseBindings() {
    self.viewModel.close
      .drive(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Data source

  private static func createDataSource() -> RxTableViewDataSource<BookmarksSection> {
    return RxTableViewDataSource(
      configureCell: { _, tableView, indexPath, model -> UITableViewCell in
        let cell = tableView.dequeueCell(ofType: BookmarksCell.self, forIndexPath: indexPath)
        cell.update(from: BookmarkCellViewModel(model))
        return cell
      },
      canEditRowAtIndexPath: { _, _ in true },
      canMoveRowAtIndexPath: { _, _ in true }
    )
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
}

// MARK: - UITableViewDelegate

extension BookmarksCard: UITableViewDelegate { }
