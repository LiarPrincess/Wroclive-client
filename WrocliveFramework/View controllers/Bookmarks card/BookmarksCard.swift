// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public final class BookmarksCard: UIViewController,
                                  UITableViewDataSource, UITableViewDelegate,
                                  BookmarksCardViewType, CardPresentable {

  // MARK: - Properties

  public let headerView = ExtraLightVisualEffectView()

  public let titleLabel = UILabel()
  public let editButton = UIButton()
  public let placeholderView = BookmarksPlaceholderView()
  public let tableView = UITableView()

  /// `self.tableView` data source
  internal var cells = [BookmarksCellViewModel]()
  internal let viewModel: BookmarksCardViewModel

  // MARK: - Init

  public init(viewModel: BookmarksCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.setView(view: self)
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.inset(scrollView: self.tableView, below: self.headerView)
  }

  // MARK: - View model

  public func refresh() {
    let newCells = self.viewModel.cells
    if newCells != self.cells {
      self.cells = newCells
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

  override public func setEditing(_ editing: Bool, animated: Bool) {
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

  // MARK: - CardPresentable

  public var scrollView: UIScrollView? {
    let isTableViewVisible = !self.tableView.isHidden
    return isTableViewVisible ? self.tableView : nil
  }

  // MARK: - UITableView

  public func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
    return self.cells.count
  }

  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellViewModel = self.cells[indexPath.row]
    let cell = self.tableView.dequeueCell(ofType: BookmarksCell.self,
                                          forIndexPath: indexPath)

    cell.update(viewModel: cellViewModel)
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
      self.cells.remove(at: index)
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

    let cell = self.cells.remove(at: fromIndex)
    self.cells.insert(cell, at: toIndex)
    self.viewModel.viewDidMoveItem(fromIndex: fromIndex, toIndex: toIndex)
  }
}
