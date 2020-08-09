// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public final class BookmarksCard:
  UIViewController, UITableViewDataSource, UITableViewDelegate,
  BookmarksCardViewType, CustomCardPanelPresentable
{
  // MARK: - Properties

  public var headerView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  public let titleLabel = UILabel()
  public let editButton = UIButton()
  public let placeholderView = BookmarksPlaceholderView()
  public let tableView = UITableView()

  /// Bookmarks data source
  internal var bookmarks = [Bookmark]()
  internal let viewModel: BookmarksCardViewModel
  internal let environment: Environment

  // MARK: - Init

  public init(viewModel: BookmarksCardViewModel, environment: Environment) {
    self.viewModel = viewModel
    self.environment = environment
    super.init(nibName: nil, bundle: nil)
    viewModel.setView(view: self)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetTableViewContentBelowHeaderView()
  }

  private func insetTableViewContentBelowHeaderView() {
    let currentInset = self.tableView.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let newInset = UIEdgeInsets(top: headerHeight,
                                  left: currentInset.left,
                                  bottom: currentInset.bottom,
                                  right: currentInset.right)
      self.tableView.contentInset = newInset
      self.tableView.scrollIndicatorInsets = newInset

      // Scroll up to preserve current scroll position
      let currentOffset = self.tableView.contentOffset
      let newOffset = CGPoint(x: currentOffset.x,
                              y: currentOffset.y + currentInset.top - headerHeight)
      self.tableView.setContentOffset(newOffset, animated: false)
    }
  }

  // MARK: - View model

  public func refresh() {
    let newBookmarks = self.viewModel.bookmarks
    if newBookmarks != self.bookmarks {
      self.bookmarks = newBookmarks
      self.tableView.reloadData()
    }

    let isTableViewVisible = self.viewModel.isTableViewVisible
    self.tableView.isHidden = !isTableViewVisible
    self.editButton.isHidden = !isTableViewVisible

    let isPlaceholderVisible = self.viewModel.isPlaceholderVisible
    self.placeholderView.isHidden = !isPlaceholderVisible

    let isEditing = self.viewModel.isEditing
    if self.isEditing != isEditing {
      self.setEditing(isEditing, animated: true)
    }

    let editButtonText = self.viewModel.editButtonText
    self.editButton.setAttributedTitle(editButtonText, for: .normal)
  }

  public override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)

    if editing {
      self.closeSwipeToDelete()
    }

    self.tableView.setEditing(editing, animated: true)
  }

  private func closeSwipeToDelete() {
    let hasSwipeToDeleteOpen = self.tableView.isEditing
    if hasSwipeToDeleteOpen {
      self.tableView.setEditing(false, animated: false)
    }
  }

  public func close(animated: Bool) {
    self.dismiss(animated: animated, completion: nil)
  }

  @objc
  public func editButtonPressed() {
    self.viewModel.viewDidPressEditButton()
  }

  // MARK: - CustomCardPanelPresentable

  public var scrollView: UIScrollView? {
    return self.tableView
  }

  // MARK: - UITableView

  public func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
    return self.bookmarks.count
  }

  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let bookmark = self.bookmarks[indexPath.row]
    let cell = self.tableView.dequeueCell(ofType: BookmarksCell.self,
                                          forIndexPath: indexPath)

    cell.update(bookmark: bookmark)
    return cell
  }

  public func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath) {
    self.viewModel.viewDidSelectItem(index: indexPath.row)
  }

  public func tableView(_ tableView: UITableView,
                        canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  public func tableView(_ tableView: UITableView,
                        canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  public func tableView(_ tableView: UITableView,
                        editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }

  public func tableView(_ tableView: UITableView,
                        commit editingStyle: UITableViewCell.EditingStyle,
                        forRowAt indexPath: IndexPath) {
    let index = indexPath.row

    switch editingStyle {
    case .delete:
      self.bookmarks.remove(at: index)
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      self.viewModel.viewDidDeleteItem(index: index)
    case .insert,
         .none:
      break
    @unknown default:
      break
    }
  }

  public func tableView(_ tableView: UITableView,
                        moveRowAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath) {
    let fromIndex = sourceIndexPath.row
    let toIndex = destinationIndexPath.row

    let bookmark = self.bookmarks.remove(at: fromIndex)
    self.bookmarks.insert(bookmark, at: toIndex)
    self.viewModel.viewDidMoveItem(fromIndex: fromIndex, toIndex: toIndex)
  }
}
