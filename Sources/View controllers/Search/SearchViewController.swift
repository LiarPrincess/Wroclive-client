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

  var selectedLines: [Line] {
    return self.tramSelectionControl.selectedLines + self.busSelectionControl.selectedLines
  }

  // MARK: Layout

  let headerViewBlur = UIBlurEffect(style: .extraLight)

  lazy var headerView: UIVisualEffectView = {
    return UIVisualEffectView(effect: self.headerViewBlur)
  }()

  let chevronView    = ChevronView()
  let cardTitle      = UILabel()
  let bookmarkButton = UIButton()
  let searchButton   = UIButton()

  let lineTypeSelector = UISegmentedControl()

  let lineSelectionPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  var tramSelectionControl: LineSelectionControl!
  var busSelectionControl:  LineSelectionControl!

  lazy var lineSelectionControls: [LineSelectionControl] = {
    return [self.tramSelectionControl, self.busSelectionControl]
  }()

  struct LineSelectionControlsIndices {
    static let tram = 0
    static let bus  = 1
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    let state = SearchViewControllerStateManager.instance.getState()
    self.initLineSelectionControls(with: state)
    self.initLayout()
    self.loadSelectorState(from: state)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetCollectionViewsBelowHeaderView()
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

  @objc func lineTypeChanged() {
    self.updatePageViewFromSelector(animated: true)
  }

  // MARK: - Methods

  // MARK: Update

  fileprivate func updateSelectorFromPageView() {
    guard let lineSelectionControl = self.lineSelectionPageViewController.viewControllers?.first as? LineSelectionControl else {
      return
    }

    guard let index = self.lineSelectionControls.index(of: lineSelectionControl) else {
      return
    }

    self.lineTypeSelector.selectedSegmentIndex = index
  }

  fileprivate func updatePageViewFromSelector(animated: Bool) {
    let selectedIndex = self.lineTypeSelector.selectedSegmentIndex

    if selectedIndex == LineSelectionControlsIndices.tram {
      let page      = self.tramSelectionControl!
      let direction = UIPageViewControllerNavigationDirection.reverse
      self.lineSelectionPageViewController.setViewControllers([page], direction: direction, animated: animated, completion: nil)
    }
    else {
      let page      = self.busSelectionControl!
      let direction = UIPageViewControllerNavigationDirection.forward
      self.lineSelectionPageViewController.setViewControllers([page], direction: direction, animated: animated, completion: nil)
    }
  }

  // MARK: LineSelectionControls

  private func initLineSelectionControls(with state: SearchViewControllerState) {
    let lines = LinesManager.instance.getLines()

    let tramLines             = lines.filter { $0.type == .tram }
    let selectedTramLines     = state.selectedLines.filter { $0.type == .tram && tramLines.contains($0) }
    self.tramSelectionControl = LineSelectionControl(withLines: tramLines, selected: selectedTramLines)

    let busLines             = lines.filter { $0.type == .bus }
    let selectedBusLines     = state.selectedLines.filter { $0.type == .bus && busLines.contains($0) }
    self.busSelectionControl = LineSelectionControl(withLines: busLines, selected: selectedBusLines)
  }

  private func insetCollectionViewsBelowHeaderView() {
    func fixInsets(in lineSelection: LineSelectionControl) {
      let currentInset = lineSelection.contentInset
      let headerHeight = self.headerView.bounds.height

      if currentInset.top < headerHeight {
        let topInset    = headerHeight
        let leftInset   = Layout.leftInset
        let rightInset  = Layout.rightInset
        let bottomInset = Layout.bottomInset

        let contentInset          = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        let scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0.0,       bottom: 0.0,         right: 0.0)

        lineSelection.contentInset          = contentInset
        lineSelection.scrollIndicatorInsets = scrollIndicatorInsets
      }
    }

    fixInsets(in: self.tramSelectionControl)
    fixInsets(in: self.busSelectionControl)
  }

  // MARK: State

  private func loadSelectorState(from state: SearchViewControllerState) {
    let isTramFilterSelected = state.lineTypeFilter == .tram
    self.lineTypeSelector.selectedSegmentIndex = isTramFilterSelected ? LineSelectionControlsIndices.tram : LineSelectionControlsIndices.bus
    self.updatePageViewFromSelector(animated: false)
  }

  private func saveState() {
    let isTramFilterSelected = self.lineTypeSelector.selectedSegmentIndex == LineSelectionControlsIndices.tram
    let lineTypeFilter: LineType = isTramFilterSelected ? .tram : .bus

    let state = SearchViewControllerState(filter: lineTypeFilter, selectedLines: self.selectedLines)
    SearchViewControllerStateManager.instance.saveState(state: state)
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

// MARK: - Add bookmark

extension SearchViewController {

  fileprivate func saveSelectedLinesAsBookmark() {
    let selectedLines = self.selectedLines

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
        Managers.bookmark.addNew(name: name, lines: strongSelf.selectedLines)

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

// MARK: UIPageViewControllerDataSource

extension SearchViewController: UIPageViewControllerDataSource {

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = self.lineSelectionControls.index(of: viewController as! LineSelectionControl) else {
      return nil
    }

    let previousIndex = index - 1
    return previousIndex >= 0 ? self.lineSelectionControls[previousIndex] : nil
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = self.lineSelectionControls.index(of: viewController as! LineSelectionControl) else {
      return nil
    }

    let nextIndex = index + 1
    return nextIndex < self.lineSelectionControls.count ? self.lineSelectionControls[nextIndex] : nil
  }

}

// MARK: - UIPageViewControllerDelegate

extension SearchViewController: UIPageViewControllerDelegate {

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      self.updateSelectorFromPageView()
    }
  }

}
