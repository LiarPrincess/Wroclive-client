//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import PromiseKit

private typealias Constants = SearchViewControllerConstants
private typealias Layout    = Constants.Layout

protocol SearchViewControllerDelegate: class {
  func searchViewController(_ viewController: SearchViewController, didSelect lines: [Line])
  func searchViewControllerDidClose(_ viewController: SearchViewController)
}

class SearchViewController: UIViewController {

  typealias Dependencies =
    HasSearchManager &
    HasBookmarksManager &
    HasNetworkManager &
    HasAlertManager &
    HasThemeManager

  // MARK: - Properties

  let managers:      Dependencies
  weak var delegate: SearchViewControllerDelegate?

  lazy var headerView: UIVisualEffectView = {
    let headerViewBlur = UIBlurEffect(style: self.managers.theme.colorScheme.blurStyle)
    return UIVisualEffectView(effect: headerViewBlur)
  }()

  let cardTitle      = UILabel()
  let bookmarkButton = UIButton()
  let searchButton   = UIButton()

  lazy var lineTypeSelector = LineTypeSelectionControl(managers: self.managers)
  lazy var linesSelector    = LineSelectionViewController(withLines: [], managers: self.managers)

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

  // MARK: - Init

  convenience init(managers: Dependencies, delegate: SearchViewControllerDelegate? = nil) {
    self.init(nibName: nil, bundle: nil, managers: managers, delegate: delegate)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, managers: Dependencies, delegate: SearchViewControllerDelegate? = nil) {
    self.managers = managers
    self.delegate = delegate
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    self.delegate?.searchViewControllerDidClose(self)
  }

  // MARK: - Actions

  @objc func bookmarkButtonPressed() {
    let selectedLines = self.linesSelector.selectedLines

    guard selectedLines.count > 0 else {
      self.managers.alert.showBookmarkNoLinesSelectedAlert(in: self)
      return
    }

    self.managers.alert.showBookmarkNameInputAlert(in: self) { name in
      guard let name = name else { return }
      self.managers.bookmarks.addNew(name: name, lines: selectedLines)
    }
  }

  @objc func searchButtonPressed() {
    guard self.mode == .selectingLines else { return }

    let lines = self.linesSelector.selectedLines
    self.delegate?.searchViewController(self, didSelect: lines)
  }

  // MARK: - Private - State

  private func loadSavedState() {
    let state = self.managers.search.getSavedState()
    self.lineTypeSelector.value = state.selectedLineType
    self.refreshAvailableLines(state.selectedLines)
  }

  private func refreshAvailableLines(_ selectedLines: [Line]) {
    self.mode = .loadingData

    firstly { return self.managers.network.getAvailableLines() }
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
        let delay = AppInfo.failedLinesRequestDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
          self?.refreshAvailableLines(selectedLines)
        }
      }

      switch error {
      case NetworkError.noInternet:
        strongSelf.managers.alert.showNoInternetAlert(in: strongSelf, retry: retry)
      default:
        strongSelf.managers.alert.showNetworkingErrorAlert(in: strongSelf, retry: retry)
      }
    }
  }

  private func saveState() {
    // if we have not downloaded lines then avoid override of state
    guard self.mode == .selectingLines else { return }

    let lineType = self.lineTypeSelector.value
    let lines    = self.linesSelector.selectedLines

    let state = SearchState(withSelected: lineType, lines: lines)
    self.managers.search.saveState(state)
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
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return Constants.CardPanel.relativeHeight * screenHeight}
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
