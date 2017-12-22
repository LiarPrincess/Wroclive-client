//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private typealias Layout       = BookmarksViewControllerConstants.Layout
private typealias TextStyles   = BookmarksViewControllerConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

protocol BookmarksViewControllerDelegate: class {
  func bookmarksViewController(_ viewController: BookmarksViewController, didSelect bookmark: Bookmark)
  func bookmarksViewControllerDidClose(_ viewController: BookmarksViewController)
}

class BookmarksViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: BookmarksViewControllerDelegate?

  let viewModel = BookmarksViewModel()
  private let disposeBag = DisposeBag()

  lazy var headerView: UIVisualEffectView = {
    let headerViewBlur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: headerViewBlur)
  }()

  let cardTitle  = UILabel()
  let editButton = UIButton()

  let bookmarksTable = UITableView()
  var bookmarksTableDataSource: BookmarksDataSource!

  let placeholderView = BookmarksPlaceholderView()

  // MARK: - Init

  convenience init(delegate: BookmarksViewControllerDelegate? = nil) {
    self.init(nibName: nil, bundle: nil, delegate: delegate)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: BookmarksViewControllerDelegate? = nil) {
    self.delegate = delegate
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initDataSource()
    self.initLayout()
    self.initBindings()
    self.showPlaceholderIfEmpty()
  }

  private func initDataSource() {
    let bookmarks = Managers.bookmarks.getAll()
    self.bookmarksTableDataSource = BookmarksDataSource(with: bookmarks, delegate: self)
  }

  private func initBindings() {
    self.initEditBindings()
  }

  private func initEditBindings() {
    // input
    self.editButton.rx.tap
      .bind(to: self.viewModel.inputs.editButtonPressed)
      .disposed(by: self.disposeBag)

    // output
    self.viewModel.outputs.isEditing
      .drive(onNext: { [weak self] in self?.setEditing($0, animated: true) })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.editButtonText
      .drive(self.editButton.rx.attributedTitle())
      .disposed(by: self.disposeBag)
  }

  // MARK: - Override

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetTableViewContentBelowHeaderView()
  }

  private func insetTableViewContentBelowHeaderView() {
    let currentInset = self.bookmarksTable.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let newInset = UIEdgeInsets(top: headerHeight, left: currentInset.left, bottom: currentInset.bottom, right: currentInset.right)
      self.bookmarksTable.contentInset          = newInset
      self.bookmarksTable.scrollIndicatorInsets = newInset

      // scroll up to preserve current scroll position
      let currentOffset = self.bookmarksTable.contentOffset
      let newOffset     = CGPoint(x: currentOffset.x, y: currentOffset.y + currentInset.top - headerHeight)
      self.bookmarksTable.setContentOffset(newOffset, animated: false)
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.delegate?.bookmarksViewControllerDidClose(self)
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    if editing { self.closeSwipeToDelte() }
    self.bookmarksTable.setEditing(editing, animated: true)
  }

  private func closeSwipeToDelte() {
    let hasSwipeToDeleteOpen = self.bookmarksTable.isEditing
    if hasSwipeToDeleteOpen {
      self.bookmarksTable.setEditing(false, animated: false)
    }
  }

  // MARK: - Actions

  fileprivate func selectBookmark(_ bookmark: Bookmark) {
    self.delegate?.bookmarksViewController(self, didSelect: bookmark)
  }

  // MARK: - Private - Placeholder

  fileprivate func showPlaceholderIfEmpty() {
    let bookmarks = self.bookmarksTableDataSource.bookmarks

    let isPlaceholderVisible = bookmarks.isEmpty
    self.editButton.isHidden      = isPlaceholderVisible
    self.placeholderView.isHidden = !isPlaceholderVisible
  }
}

// MARK: - CardPanelPresentable

extension BookmarksViewController: CardPanelPresentable {
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return Layout.CardPanel.height }
}

// MARK: - UITableViewDelegate

extension BookmarksViewController: UITableViewDelegate {

  // MARK: Height

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return Layout.TableView.estimatedCellHeight
  }

  // MARK: - Selection

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let bookmark = self.bookmarksTableDataSource.bookmarkAt(indexPath.row)
    self.selectBookmark(bookmark)
  }
}

// MARK: - BookmarksDataSourceDelegate

extension BookmarksViewController: BookmarksDataSourceDelegate {

  func dataSource(_ dataSource: BookmarksDataSource, didDelete bookmark: Bookmark) {
    self.saveBookmarks()
    self.showPlaceholderIfEmpty()
  }

  func didReorderBookmarks(_ dataSource: BookmarksDataSource) {
    self.saveBookmarks()
  }

  private func saveBookmarks() {
    let bookmarks = self.bookmarksTableDataSource.bookmarks
    Managers.bookmarks.save(bookmarks)
  }
}
