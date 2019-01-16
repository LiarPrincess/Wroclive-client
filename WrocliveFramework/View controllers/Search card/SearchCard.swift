// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

private typealias Layout       = SearchCardConstants.Layout
private typealias Localization = Localizable.Search

public final class SearchCard: UIViewController, CustomCardPanelPresentable, ChevronViewOwner {

  // MARK: - Properties

  private let viewModel: SearchCardViewModel
  private let disposeBag = DisposeBag()

  public var headerView: UIVisualEffectView = {
    let headerViewBlur = UIBlurEffect(style: Theme.colors.blurStyle)
    return UIVisualEffectView(effect: headerViewBlur)
  }()

  public let chevronView     = ChevronView()
  public let titleLabel      = UILabel()
  public let bookmarkButton  = UIButton()
  public let searchButton    = UIButton()
  public let placeholderView = SearchPlaceholderView()

  public lazy var lineTypeSelector = LineTypeSelector(self.viewModel.lineTypeSelectorViewModel)
  public let lineSelector = LineSelector()

  // MARK: - Card panel

  public var scrollView: UIScrollView? { return self.lineSelector.scrollView }

  // MARK: - Init

  public init(_ viewModel: SearchCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initPageBindings()
    self.initLineBindings()
    self.initVisibilityBindings()
    self.initButtonBindings()
    self.initAlertBindings()
    self.initViewControlerLifecycleBindings()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initPageBindings() {
    self.lineSelector.rx.pageDidTransition
      .bind(to: self.viewModel.didTransitionToPage)
      .disposed(by: self.disposeBag)

    self.viewModel.page
      .drive(onNext: { [weak self] newValue in
        self?.lineSelector.setPage(newValue, animated: true)
      })
      .disposed(by: self.disposeBag)
  }

  private func initLineBindings() {
    self.lineSelector.rx.lineSelected
      .bind(to: self.viewModel.didSelectLine)
      .disposed(by: self.disposeBag)

    self.lineSelector.rx.lineDeselected
      .bind(to: self.viewModel.didDeselectLine)
      .disposed(by: self.disposeBag)

    self.viewModel.lines
      .withLatestFrom(self.viewModel.selectedLines) { (lines: $0, selectedLines: $1) }
      .drive(onNext: { [weak self] in self?.lineSelector.setLines($0.lines, selected: $0.selectedLines) })
      .disposed(by: self.disposeBag)
  }

  private func initVisibilityBindings() {
    self.viewModel.isLineSelectorVisible
      .drive(self.lineSelector.view.rx.isVisible)
      .disposed(by: self.disposeBag)

    self.viewModel.isPlaceholderVisible
      .drive(self.placeholderView.rx.isVisible)
      .disposed(by: self.disposeBag)
  }

  private func initButtonBindings() {
    self.bookmarkButton.rx.tap
      .bind(to: self.viewModel.didPressBookmarkButton)
      .disposed(by: self.disposeBag)

    self.searchButton.rx.tap
      .bind(to: self.viewModel.didPressSearchButton)
      .disposed(by: self.disposeBag)
  }

  private func initAlertBindings() {
    self.viewModel.showAlert.asObservable()
      .flatMapLatest(createBookmarkNameAlert)
      .unwrap()
      .bind(to: self.viewModel.didEnterBookmarkName)
      .disposed(by: self.disposeBag)

    self.viewModel.showAlert.asObservable()
      .flatMapLatest(createAlert)
      .subscribe()
      .disposed(by: self.disposeBag)
  }

  private func initViewControlerLifecycleBindings() {
    // modal view controllers can send multiple messages when user cancels gesture
    // also simple binding would propagate also .onCompleted events
    self.rx.methodInvoked(#selector(SearchCard.viewDidLoad))
      .take(1)
      .bind { [weak self] _ in self?.viewModel.viewDidLoad.onNext() }
      .disposed(by: self.disposeBag)

    self.viewModel.close
      .drive(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Overriden

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.insetLineSelectorBelowHeaderView()
  }

  private func insetLineSelectorBelowHeaderView() {
    let currentInset = self.lineSelector.contentInset
    let headerHeight = self.headerView.bounds.height

    if currentInset.top < headerHeight {
      let topInset    = headerHeight
      let leftInset   = Layout.leftInset
      let rightInset  = Layout.rightInset
      let bottomInset = Layout.LineSelector.bottomInset

      self.lineSelector.contentInset          = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
      self.lineSelector.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0.0,       bottom: 0.0,         right: 0.0)
    }
  }

  // MARK: - CustomCardPanelPresentable

  public func interactiveDismissalProgress(percent: CGFloat) {
    self.updateChevronViewDuringInteractiveDismissal(percent: percent)
  }

  public func interactiveDismissalDidEnd(completed: Bool) {
    self.updateChevronViewAfterInteractiveDismissal()
  }
}

// MARK: - Helpers

private func createBookmarkNameAlert(_ alert: SearchCardAlert) -> Observable<String?> {
  switch alert {
  case .bookmarkNameInput: return BookmarkAlerts.showNameInputAlert()
  default: return .never()
  }
}

private func createAlert(_ alert: SearchCardAlert) -> Observable<Void> {
  switch alert {
  case .bookmarkNoLineSelected: return BookmarkAlerts.showNoLinesSelectedAlert()
  case let .apiError(error):
    switch error {
    case .noInternet:      return NetworkAlerts.showNoInternetAlert()
    case .invalidResponse,
         .generalError:    return NetworkAlerts.showConnectionErrorAlert()
    }
  default: return .never()
  }
}
