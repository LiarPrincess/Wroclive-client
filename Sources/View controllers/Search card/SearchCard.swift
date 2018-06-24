// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

private typealias Layout       = SearchCardConstants.Layout
private typealias Localization = Localizable.Search

class SearchCard: CardPanel {

  // MARK: - Properties

  private let viewModel: SearchCardViewModel
  private let disposeBag = DisposeBag()

  var headerView: UIVisualEffectView = {
    let headerViewBlur = UIBlurEffect(style: AppEnvironment.theme.colors.blurStyle)
    return UIVisualEffectView(effect: headerViewBlur)
  }()

  let titleLabel      = UILabel()
  let bookmarkButton  = UIButton()
  let searchButton    = UIButton()
  let placeholderView = SearchPlaceholderView()

  let lineTypeSelector = LineTypeSelector()
  let lineSelector     = LineSelector()

  // MARK: - Card panel

  override var height:     CGFloat       { return Layout.height  }
  override var scrollView: UIScrollView? { return self.lineSelector.scrollView }

  // MARK: - Init

  init(_ viewModel: SearchCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initPageBindings()
    self.initLineBindings()
    self.initVisibilityBindings()
    self.initButtonBindings()
    self.initAlertBindings()
    self.initViewControlerLifecycleBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initPageBindings() {
    self.lineTypeSelector.rx.selectedValueChanged
      .bind(to: self.viewModel.didSelectPage)
      .disposed(by: self.disposeBag)

    self.lineSelector.rx.pageDidTransition
      .bind(to: self.viewModel.didTransitionToPage)
      .disposed(by: self.disposeBag)

    self.viewModel.page
      .drive(onNext: { [weak self] newValue in
        self?.lineTypeSelector.selectedValue = newValue
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
    self.rx.methodInvoked(#selector(SearchCard.viewDidAppear(_:)))
      .take(1)
      .bind { [weak self] _ in self?.viewModel.viewDidAppear.onNext() }
      .disposed(by: self.disposeBag)

    self.rx.methodInvoked(#selector(SearchCard.viewDidDisappear(_:)))
      .map { _ in () }
      .bind(to: self.viewModel.viewDidDisappear)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidLayoutSubviews() {
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
