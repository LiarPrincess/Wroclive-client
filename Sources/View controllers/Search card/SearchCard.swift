//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias CardPanel    = SearchCardConstants.CardPanel
private typealias Layout       = SearchCardConstants.Layout
private typealias Localization = Localizable.Search

class SearchCard: UIViewController {

  // MARK: - Properties

  private let viewModel: SearchCardViewModel
  private let disposeBag = DisposeBag()

  var headerView: UIVisualEffectView = {
    let headerViewBlur = UIBlurEffect(style: Managers.theme.colors.blurStyle)
    return UIVisualEffectView(effect: headerViewBlur)
  }()

  let titleLabel      = UILabel()
  let bookmarkButton  = UIButton()
  let searchButton    = UIButton()
  let placeholderView = SearchPlaceholderView()

  let lineTypeSelector = LineTypeSelector()
  let lineSelector     = LineSelector()

  // MARK: - Init

  init(_ viewModel: SearchCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initPageBindings()
    self.initLineSelectorBindings()
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
      .bind(to: self.viewModel.inputs.pageSelected)
      .disposed(by: self.disposeBag)

    self.lineSelector.viewModel.outputs.page
      .drive(self.viewModel.inputs.pageDidTransition)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.page
      .drive(onNext: { [weak self] newValue in
        self?.lineTypeSelector.selectedValue = newValue
        self?.lineSelector.setCurrentPageNotReactive(newValue, animated: true)
      })
      .disposed(by: self.disposeBag)
  }

  private func initLineSelectorBindings() {
    self.viewModel.outputs.lines
      .drive(onNext: { [weak self] lines in
        self?.lineSelector.viewModel.inputs.linesChanged.onNext(lines.lines)
        self?.lineSelector.viewModel.inputs.selectedLinesChanged.onNext(lines.selectedLines)
      })
      .disposed(by: self.disposeBag)
  }

  private func initVisibilityBindings() {
    self.viewModel.outputs.isLineSelectorVisible
      .drive(self.lineSelector.view.rx.isVisible)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.isPlaceholderVisible
      .drive(self.placeholderView.rx.isVisible)
      .disposed(by: self.disposeBag)
  }

  private func initButtonBindings() {
    self.bookmarkButton.rx.tap
      .bind(to: self.viewModel.inputs.bookmarkButtonPressed)
      .disposed(by: self.disposeBag)

    self.searchButton.rx.tap
      .bind(to: self.viewModel.inputs.searchButtonPressed)
      .disposed(by: self.disposeBag)
  }

  private func initAlertBindings() {
    self.viewModel.outputs.showBookmarkAlert.asObservable()
      .flatMapLatest(self.createAlert)
      .bind(to: self.viewModel.inputs.bookmarkAlertNameEntered)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showApiErrorAlert.asObservable()
      .flatMapLatest(self.createAlert)
      .bind(to: self.viewModel.inputs.apiAlertTryAgainButtonPressed)
      .disposed(by: self.disposeBag)
  }

  private func createAlert(_ bookmarkAlert: SearchCardBookmarkAlert) -> Observable<String?> {
    switch bookmarkAlert {
    case .nameInput:     return BookmarkAlerts.showNameInputAlert(in: self)
    case .noLineSelcted: return BookmarkAlerts.showNoLinesSelectedAlert(in: self).map { _ in  nil }
    }
  }

  private func createAlert(_ apiAlert: SearchCardApiAlert) -> Observable<Void> {
    switch apiAlert {
    case .noInternet:      return NetworkAlerts.showNoInternetAlert(in: self)
    case .connectionError: return NetworkAlerts.showConnectionErrorAlert(in: self)
    }
  }

  private func initViewControlerLifecycleBindings() {
    self.viewModel.outputs.shouldClose
      .drive(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
      .disposed(by: self.disposeBag)

    // modal view controllers can send multiple messages when user cancels gesture
    // also simple binding would propagate also .onCompleted events
    self.rx.methodInvoked(#selector(SearchCard.viewDidAppear(_:)))
      .take(1)
      .bind { [weak self] _ in self?.viewModel.inputs.viewDidAppear.onNext() }
      .disposed(by: self.disposeBag)

    self.rx.methodInvoked(#selector(SearchCard.viewDidDisappear(_:)))
      .map { _ in () }
      .bind(to: self.viewModel.inputs.viewDidDisappear)
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
      let bottomInset = Layout.bottomInset

      self.lineSelector.contentInset          = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
      self.lineSelector.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0.0,       bottom: 0.0,         right: 0.0)
    }
  }
}

// MARK: - CardPanelPresentable

extension SearchCard: CardPanelPresentable {
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return CardPanel.height }
}
