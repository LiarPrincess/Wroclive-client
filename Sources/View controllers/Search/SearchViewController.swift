//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import PromiseKit

private typealias Constants    = SearchViewControllerConstants
private typealias Layout       = Constants.Layout
private typealias Localization = Localizable.Search

protocol SearchViewControllerDelegate: class {
  func searchViewController(_ viewController: SearchViewController, didSelect lines: [Line])
  func searchViewControllerDidClose(_ viewController: SearchViewController)
}

class SearchViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: SearchViewControllerDelegate?

  lazy var headerView: UIVisualEffectView = {
    let headerViewBlur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: headerViewBlur)
  }()

  let cardTitle      = UILabel()
  let bookmarkButton = UIButton()
  let searchButton   = UIButton()

  lazy var lineTypeSelector = LineTypeSelectionControl()
  lazy var linesSelector    = LineSelectionViewController(withLines: [])

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

  convenience init(delegate: SearchViewControllerDelegate? = nil) {
    self.init(nibName: nil, bundle: nil, delegate: delegate)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: SearchViewControllerDelegate? = nil) {
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

  @objc
  func bookmarkButtonPressed() {
    let selectedLines = self.linesSelector.selectedLines

    guard selectedLines.any else {
      Managers.alert.showBookmarkNoLinesSelectedAlert(in: self)
      return
    }

    Managers.alert.showBookmarkNameInputAlert(in: self) { [weak self] name in
      guard let name = name else { return }
      let bookmark = Bookmark(name: name, lines: selectedLines)
      Managers.bookmarks.addNew(bookmark)
      self?.showBookmarkCreatedPopup()
    }
  }

  private func showBookmarkCreatedPopup() {
    let image   = StyleKit.drawStarFilledTemplateImage(size: Constants.BookmarksPopup.imageSize)
    let title   = Localization.BookmarkAdded.title
    let caption = Localization.BookmarkAdded.caption

    let popup = PopupView(image: image, title: title, caption: caption)

    self.view.addSubview(popup)
    popup.snp.makeConstraints { make in
      let centerOwner: ConstraintView = self.view.window ?? self.view
      make.center.equalTo(centerOwner.snp.center)
    }

    let delay    = Constants.BookmarksPopup.delay
    let duration = Constants.BookmarksPopup.duration

    UIView.animateKeyframes(withDuration: duration, delay: delay, options: [],
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.00, relativeDuration: 0.00, animations: {
          popup.alpha     = 0.0
          popup.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })

        // present
        UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.10, animations: {
          popup.alpha = 0.5
        })

        UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.10, animations: {
          popup.alpha     = 1.0
          popup.transform = CGAffineTransform.identity
        })

        // dismiss
        UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.10, animations: {
          popup.alpha     = 0.5
          popup.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })

        UIView.addKeyframe(withRelativeStartTime: 0.95, relativeDuration: 0.05, animations: {
          popup.alpha = 0.0
        })
      },
      completion: { _ in popup.removeFromSuperview() }
    )
  }

  @objc
  func searchButtonPressed() {
    guard self.mode == .selectingLines else { return }

    let lines = self.linesSelector.selectedLines
    self.delegate?.searchViewController(self, didSelect: lines)
  }

  // MARK: - Private - State

  private func loadSavedState() {
    let state = Managers.search.getSavedState()
    self.lineTypeSelector.value = state.selectedLineType
    self.refreshAvailableLines(state.selectedLines)
  }

  private func refreshAvailableLines(_ selectedLines: [Line]) {
    self.mode = .loadingData

    firstly { return Managers.api.getAvailableLines() }
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
  func pageViewController(
      _ pageViewController: UIPageViewController,
      didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController],
      transitionCompleted completed: Bool) {
    if completed {
      self.updateViewFromLineSelector()
    }
  }
}
