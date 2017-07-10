//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = SearchViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

class SearchViewController: UIViewController {

  // MARK: - Properties

  let headerViewBlur = UIBlurEffect(style: .extraLight)

  lazy var headerView: UIVisualEffectView = {
    return UIVisualEffectView(effect: self.headerViewBlur)
  }()

  let chevronView    = ChevronView()
  let cardTitle      = UILabel()
  let bookmarkButton = UIButton()
  let searchButton   = UIButton()

  let lineTypeSelector = LineTypeSelectionControl()

  lazy var linesSelector: LineSelectionViewController = {
    let lines = Managers.lines.getAll()
    return LineSelectionViewController(withLines: lines)
  }()

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
    self.loadLastState()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetLineSelectorBelowHeaderView()
  }

  private func insetLineSelectorBelowHeaderView() {
    let currentInset = self.linesSelector.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let topInset    = headerHeight
      let leftInset   = Layout.leftInset
      let rightInset  = Layout.rightInset
      let bottomInset = Layout.bottomInset

      self.linesSelector.contentInset          = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
      self.linesSelector.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0.0,       bottom: 0.0,         right: 0.0)
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    self.saveState()
  }

  // MARK: - Actions

  @objc func bookmarkButtonPressed() {
    self.saveSelectedLinesAsBookmark()
  }

  @objc func searchButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - State

  private func loadLastState() {
    let state = Managers.searchState.getLatest()
    self.lineTypeSelector.value      = state.selectedLineType
    self.linesSelector.selectedLines = state.selectedLines
    self.updateViewFromLineTypeSelector(animated: false)
  }

  private func saveState() {
    let lineType = self.lineTypeSelector.value
    let lines    = self.linesSelector.selectedLines

    let state = SearchState(withSelected: lineType, lines: lines)
    Managers.searchState.save(state)
  }

  // MARK: - Update methods

  fileprivate func updateViewFromLineSelector() {
    let lineType = self.linesSelector.selectedLineType

    if self.lineTypeSelector.value != lineType {
      self.lineTypeSelector.value = lineType
    }
  }

  fileprivate func updateViewFromLineTypeSelector(animated: Bool) {
    let lineType = self.lineTypeSelector.value

    if lineType != self.linesSelector.selectedLineType {
      self.linesSelector.setLineType(lineType, animated: animated)
    }
  }

}

// MARK: - CardPanelPresentable

extension SearchViewController : CardPanelPresentable {
  var contentView:       UIView { return self.view }
  var interactionTarget: UIView { return self.headerView }

  func dismissalTransitionWillBegin() {
    self.chevronView.setState(.flat, animated: true)
  }

  func dismissalTransitionDidEnd(_ completed: Bool) {
    if !completed {
      self.chevronView.setState(.down, animated: true)
    }
  }
}

// MARK: - LineTypeSelectionControlDelegate

extension SearchViewController: LineTypeSelectionControlDelegate {
  func lineTypeSelectionControl(control: LineTypeSelectionControl, didSelect lineType: LineType) {
    self.updateViewFromLineTypeSelector(animated: true)
  }
}

// MARK: - LineSelectionViewControllerDelegate

extension SearchViewController: LineSelectionViewControllerDelegate {
  func lineSelectionViewController(controller: LineSelectionViewController, didChangePage lineType: LineType) {
    self.updateViewFromLineSelector()
  }
}

// MARK: - Add bookmark

extension SearchViewController {

  fileprivate func saveSelectedLinesAsBookmark() {
    let selectedLines = self.linesSelector.selectedLines

    if selectedLines.count > 0 {
      self.showBookmarkCreationAlert()
    }
    else { self.showNoLinesSelectedAlert() }
  }

  private func showBookmarkCreationAlert() {
    let nameAlertBuilder = TextInputAlertBuilder(title: "New bookmark")
    nameAlertBuilder.message            = "Enter name for this bookmark."
    nameAlertBuilder.placeholder        = "Name"
    nameAlertBuilder.confirmButtonTitle = "Save"
    nameAlertBuilder.cancelButtonTitle  = "Cancel"

    nameAlertBuilder.completion = { [weak self] result in
      guard let strongSelf = self else {
        return
      }

      if case let .confirm(name) = result {
        Managers.bookmark.addNew(name: name, lines: strongSelf.linesSelector.selectedLines)

        // if its the 1st bookmark then show some instructions
        let bookmarks = Managers.bookmark.getAll()
        if bookmarks.count == 1 {
          let instructionsAlertBuilder = TextAlertBuilder(title: "Bookmark saved")
          instructionsAlertBuilder.message          = "To view saved bookmarks select star from map view."
          instructionsAlertBuilder.closeButtonTitle = "Got it!"

          strongSelf.present(instructionsAlertBuilder.create(), animated: true, completion: nil)
        }
      }
    }

    self.present(nameAlertBuilder.create(), animated: true, completion: nil)
  }

  private func showNoLinesSelectedAlert() {
    let alertBuilder              = TextAlertBuilder(title: "No lines selected")
    alertBuilder.message          = "Please select some lines before trying to create bookmark."
    alertBuilder.closeButtonTitle = "Ok"
    self.present(alertBuilder.create(), animated: true, completion: nil)
  }

}
