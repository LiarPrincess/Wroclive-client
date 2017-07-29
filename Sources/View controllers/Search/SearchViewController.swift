//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import PromiseKit

fileprivate typealias Constants = SearchViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

class SearchViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: SearchViewControllerDelegate?

  let headerViewBlur = UIBlurEffect(style: .extraLight)

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
    let selectedLines = self.linesSelector.selectedLines

    guard selectedLines.count > 0 else {
      Managers.alert.showBookmarkNoLinesSelectedAlert(in: self)
      return
    }

    Managers.alert.showBookmarkNameInputAlert(in: self) { [weak self] name in
      guard let strongSelf = self, let name = name else {
        return
      }

      Managers.bookmark.addNew(name: name, lines: selectedLines)

      // if its the 1st bookmark then show some instructions
      let hasSeenInstruction = Managers.bookmark.hasSeenInstruction
      if !hasSeenInstruction {
        Managers.alert.showBookmarkInstructionsAlert(in: strongSelf)
        Managers.bookmark.hasSeenInstruction = true
      }
    }
  }

  @objc func searchButtonPressed() {
    let selectedLines = self.linesSelector.selectedLines
    self.delegate?.searchViewController(self, didSelect: selectedLines)
    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - Private - State

  private func loadLastState() {
    self.mode = .loadingData

    let state = Managers.search.getLatest()
    self.lineTypeSelector.value = state.selectedLineType
    self.refreshAvailableLines(state.selectedLines)
  }

  private var isVisible: Bool { return self.isViewLoaded && self.view.window != nil }

  private func refreshAvailableLines(_ selectedLines: [Line]) {
    self.mode = .loadingData
    _ = Managers.lines.getAll()
      .then { lines -> () in
        guard self.isVisible else { return }
        self.linesSelector.lines         = lines
        self.linesSelector.selectedLines = selectedLines

        self.mode = .selectingLines
        self.updateViewFromLineTypeSelector(animated: false)
      }
      .catch { error in
        guard self.isVisible else { return }

        let retry: () -> () = {
          let delay = Constants.Network.failedRequestDelay
          DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.refreshAvailableLines(selectedLines)
          }
        }

        switch error {
        case NetworkingError.noInternet:
          Managers.alert.showNoInternetAlert(in: self, retry: retry)
        default:
          Managers.alert.showNetworkingErrorAlert(in: self, retry: retry)
        }
      }
  }

  private func saveState() {
    let lineType = self.lineTypeSelector.value
    let lines    = self.linesSelector.selectedLines

    let state = SearchState(withSelected: lineType, lines: lines)
    Managers.search.save(state)
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
