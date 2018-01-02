//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias CardPanel    = SearchViewControllerConstants.CardPanel
private typealias Layout       = SearchViewControllerConstants.Layout
private typealias Localization = Localizable.Search

class SearchViewController: UIViewController {

  // MARK: - Properties

  private let viewModel: SearchViewModel
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
  let lineSelector     = LineSelectionViewController()

  // MARK: - Init

  init(_ viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.initPageBindings()
    self.initLineBindings()
    self.initButtonBindings()
    self.initVisibilityBindings()
    self.initCloseBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initPageBindings() {
    // outputs first, so we sync with view model
    self.viewModel.outputs.page
      .drive(onNext: { [weak self] newValue in
        self?.lineTypeSelector.selectedValue = newValue
        self?.lineSelector.setCurrentPageNotReactive(newValue, animated: true)
      })
      .disposed(by: self.disposeBag)

    // inputs
    self.lineTypeSelector.rx.selectedValueChanged
      .bind(to: self.viewModel.inputs.lineTypeSelectorPageChanged)
      .disposed(by: self.disposeBag)

    self.lineSelector.viewModel.outputs.page
      .drive(self.viewModel.inputs.lineSelectorPageChanged)
      .disposed(by: self.disposeBag)
  }

  private func initLineBindings() {
    self.viewModel.outputs.lines
      .drive(self.lineSelector.viewModel.inputs.linesChanged)
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

  private func initVisibilityBindings() {
    self.viewModel.outputs.isLineSelectorVisible
      .drive(self.lineSelector.view.rx.isVisible)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.isPlaceholderVisible
      .drive(self.placeholderView.rx.isVisible)
      .disposed(by: self.disposeBag)
  }

  private func initCloseBindings() {
    self.viewModel.outputs.shouldClose
      .drive(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
      .disposed(by: self.disposeBag)

    self.rx.methodInvoked(#selector(SearchViewController.viewDidDisappear(_:)))
      .map { _ in () }
      .bind(to: self.viewModel.inputs.didClose)
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

extension SearchViewController : CardPanelPresentable {
  var header: UIView  { return self.headerView.contentView }
  var height: CGFloat { return CardPanel.height }
}
