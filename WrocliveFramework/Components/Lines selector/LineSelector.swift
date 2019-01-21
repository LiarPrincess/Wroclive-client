// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

public final class LineSelector: UIPageViewController {

  // MARK: - Properties

  private let viewModel: LineSelectorViewModel
  private let disposeBag = DisposeBag()

  private let tramPage: LineSelectorPage
  private let busPage:  LineSelectorPage
  private lazy var pages = [self.tramPage, self.busPage]

  public var contentInset: UIEdgeInsets {
    get { return self.tramPage.contentInset }
    set { self.pages.forEach { $0.contentInset = newValue } }
  }

  public var scrollIndicatorInsets: UIEdgeInsets {
    get { return self.tramPage.scrollIndicatorInsets }
    set { self.pages.forEach { $0.scrollIndicatorInsets = newValue } }
  }

  public var scrollView: UIScrollView {
    switch self.currentPage {
    case .tram: return self.tramPage.scrollView
    case .bus:  return self.busPage .scrollView
    }
  }

  private var currentPage: LineType {
    let page = self.viewControllers?.first
    if page === self.tramPage { return .tram }
    if page === self.busPage  { return .bus  }
    fatalError("Invalid page selected")
  }

  // MARK: - Init

  public init(_ viewModel: LineSelectorViewModel) {
    self.viewModel = viewModel
    self.tramPage = LineSelectorPage(viewModel.tramPageViewModel)
    self.busPage  = LineSelectorPage(viewModel.busPageViewModel)
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    // load views so we can select/deselect cells right away
    self.pages.forEach { _ = $0.view }

    self.delegate   = self
    self.dataSource = self

    self.initLayout()
    self.initBindings()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    // show 1st page as default
    let firstPage = self.pages[0]
    self.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
  }

  private func initBindings() {
    self.viewModel.page
      .drive(onNext: { [unowned self] in self.setPage($0, animated: true) })
      .disposed(by: self.disposeBag)

    // we use 'UIPageViewControllerDelegate' instead of raw binding for input
  }

  // MARK: - Setters

  private func setPage(_ lineType: LineType, animated: Bool) {
    typealias Direction = UIPageViewController.NavigationDirection

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
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerBefore viewController: UIViewController) -> UIViewController? {

    guard let index = self.index(of: viewController)
      else { return nil }

    let previousIndex = index - 1
    return previousIndex >= 0 ? self.pages[previousIndex] : nil
  }

  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController) -> UIViewController? {

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

  public func pageViewController(_ pageViewController:          UIPageViewController,
                                 didFinishAnimating finished:   Bool,
                                 previousViewControllers:       [UIViewController],
                                 transitionCompleted completed: Bool) {
    if completed {
      self.viewModel.didTransitionToPage.onNext(self.currentPage)
    }
  }
}
