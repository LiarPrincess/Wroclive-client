//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import PromiseKit

private typealias Constants = SearchViewControllerConstants
private typealias Layout    = Constants.Layout

class SearchViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: SearchViewControllerDelegate?

  let headerViewBlur = UIBlurEffect(style: Managers.theme.colorScheme.blurStyle)

  lazy var headerView: UIVisualEffectView = {
    return UIVisualEffectView(effect: self.headerViewBlur)
  }()

  let chevronView    = ChevronView()
  let cardTitle      = UILabel()
  let bookmarkButton = UIButton()
  let searchButton   = UIButton()

  let lineTypeSelector = LineTypeSelectionControl()
  let linesSelector    = LineSelectionViewController(withLines: [])

  let placeholderView    = UIView()
  let placeholderLabel   = UILabel()
  let placeholderSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  fileprivate enum ControlMode {
    case loadingData, selectingLines
  }

  fileprivate var mode: ControlMode = .loadingData {
    didSet {
      switch self.mode {
      case .loadingData:
        self.placeholderSpinner.startAnimating()
        self.placeholderView.isHidden    = false
        self.linesSelector.view.isHidden = true

      case .selectingLines:
        self.placeholderSpinner.stopAnimating()
        self.placeholderView.isHidden    = true
        self.linesSelector.view.isHidden = false
      }
    }
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
    self.loadSavedState()
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
    super.viewDidDisappear(animated)
    self.saveState()
  }

  // MARK: - Actions

  @objc func bookmarkButtonPressed() {
    let selectedLines = self.linesSelector.selectedLines

    guard selectedLines.count > 0 else {
      Managers.alert.showBookmarkNoLinesSelectedAlert(in: self)
      return
    }

    Managers.alert.showBookmarkNameInputAlert(in: self) { name in
      guard let name = name else { return }
      Managers.bookmarks.addNew(name: name, lines: selectedLines)
    }
  }

  @objc func searchButtonPressed() {
    if self.mode == .selectingLines {
      let selectedLines = self.linesSelector.selectedLines
      self.delegate?.searchViewController(self, didSelect: selectedLines)
    }

    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - Private - State

  private func loadSavedState() {
    let state = Managers.search.getSavedState()
    self.lineTypeSelector.value = state.selectedLineType
    self.refreshAvailableLines(state.selectedLines)
  }

  private func refreshAvailableLines(_ selectedLines: [Line]) {
    self.mode = .loadingData

    firstly { return Managers.network.getAvailableLines() }
    .then { [weak self] lines -> () in
      guard let strongSelf = self else { return }

      strongSelf.linesSelector.lines         = lines
      strongSelf.linesSelector.selectedLines = selectedLines

      strongSelf.mode = .selectingLines
      strongSelf.updateViewFromLineTypeSelector(animated: false)
    }
    .catch { [weak self] error in
      guard let strongSelf = self else { return }

      let retry = { [weak self] in
        let delay = Constants.Network.failedRequestDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
          self?.refreshAvailableLines(selectedLines)
        }
      }

      switch error {
      case NetworkError.noInternet:
        Managers.alert.showNoInternetAlert(in: strongSelf, retry: retry)
      default:
        Managers.alert.showNetworkingErrorAlert(in: strongSelf, retry: retry)
      }
    }
  }

  private func saveState() {
    // if we have not downloaded lines then avoid override of state
    guard self.mode == .selectingLines else { return }

    let lineType = self.lineTypeSelector.value
    let lines    = self.linesSelector.selectedLines

    let state = SearchState(withSelected: lineType, lines: lines)
    Managers.search.saveState(state)
  }

  // MARK: - Private - Update methods

  fileprivate func updateViewFromLineSelector() {
    guard self.mode == .selectingLines else { return }

    let lineType = self.linesSelector.currentPage
    if self.lineTypeSelector.value != lineType {
      self.lineTypeSelector.value = lineType
    }
  }

  fileprivate func updateViewFromLineTypeSelector(animated: Bool) {
    guard self.mode == .selectingLines else { return }

    let lineType = self.lineTypeSelector.value
    if lineType != self.linesSelector.currentPage {
      self.linesSelector.setCurrentPage(lineType, animated: animated)
    }
  }
}

// MARK: - CardPanelPresentable

extension SearchViewController : CardPanelPresentable {
  var relativeHeight:    CGFloat { return Constants.CardPanel.relativeHeight }
  var contentView:       UIView  { return self.view }
  var interactionTarget: UIView  { return self.headerView }

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
  func lineTypeSelectionControl(_ control: LineTypeSelectionControl, didSelect lineType: LineType) {
    self.updateViewFromLineTypeSelector(animated: true)
  }
}

// MARK: - LineSelectionViewControllerDelegate

extension SearchViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      self.updateViewFromLineSelector()
    }
  }
}
