//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LineSelector: UIPageViewController {

  // MARK: - Properties

  let viewModel = LineSelectorViewModel()
  private let disposeBag = DisposeBag()

  private let tramPage = LineSelectorPage()
  private let busPage  = LineSelectorPage()
  private lazy var pages = [self.tramPage, self.busPage]

  var currentPage: LineType {
    let page = self.viewControllers?.first
    if page === self.tramPage { return .tram }
    if page === self.busPage  { return  .bus }
    fatalError("Invalid page selected")
  }

  var contentInset: UIEdgeInsets {
    get { return self.tramPage.contentInset }
    set { self.pages.forEach { $0.contentInset = newValue } }
  }

  var scrollIndicatorInsets: UIEdgeInsets {
    get { return self.tramPage.scrollIndicatorInsets }
    set { self.pages.forEach { $0.scrollIndicatorInsets = newValue } }
  }

  // MARK: - Init

  init() {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    // load views so we can select/deselect cells right away
    self.pages.forEach { _ = $0.view }

    self.delegate   = self
    self.dataSource = self

    self.initLayout()
    self.initBindings()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    // show 1st page as default
    let firstPage = self.pages[0]
    self.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
  }

  private func initBindings() {
    // input page bindings are handled in:
    // self.pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:)

    self.viewModel.outputs.tramLines
      .drive(self.tramPage.viewModel.inputs.linesChanged)
      .disposed(by: disposeBag)

    self.viewModel.outputs.busLines
      .drive(self.busPage.viewModel.inputs.linesChanged)
      .disposed(by: disposeBag)

    self.viewModel.outputs.selectedTramLines
      .drive(self.tramPage.viewModel.inputs.selectedLinesChanged)
      .disposed(by: disposeBag)

    self.viewModel.outputs.selectedBusLines
      .drive(self.busPage.viewModel.inputs.selectedLinesChanged)
      .disposed(by: disposeBag)
  }

  // MARK: - Current page

  /// Set current page without invoking Rx observers
  func setCurrentPageNotReactive(_ lineType: LineType, animated: Bool) {
    typealias Direction = UIPageViewControllerNavigationDirection

    let isTram    = lineType == .tram
    let page      = isTram ? self.tramPage     : self.busPage
    let direction = isTram ? Direction.reverse : Direction.forward

    let selectedPage = self.viewControllers?.first
    if selectedPage !== page {
      self.setViewControllers([page], direction: direction, animated: animated, completion: nil)
    }
  }
}

// MARK: UIPageViewControllerDataSource

extension LineSelector: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = self.index(of: viewController)
      else { return nil }

    let previousIndex = index - 1
    return previousIndex >= 0 ? self.pages[previousIndex] : nil
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = self.index(of: viewController)
      else { return nil }

    let nextIndex = index + 1
    return nextIndex < self.pages.count ? self.pages[nextIndex] : nil
  }

  private func index(of viewController: UIViewController) -> Int? {
    return self.pages.index { $0 === viewController }
  }
}

// MARK: - UIPageViewControllerDelegate

extension LineSelector: UIPageViewControllerDelegate {

  func pageViewController(_ pageViewController:          UIPageViewController,
                          didFinishAnimating finished:   Bool,
                          previousViewControllers:       [UIViewController],
                          transitionCompleted completed: Bool) {
    if completed {
      let currentPage = self.currentPage
      self.viewModel.inputs.pageChanged.onNext(currentPage)
    }
  }
}
