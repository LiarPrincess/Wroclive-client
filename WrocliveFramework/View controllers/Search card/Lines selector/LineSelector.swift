// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public final class LineSelector:
  UIPageViewController,
  UIPageViewControllerDataSource, UIPageViewControllerDelegate,
  LineSelectorViewType
{

  // MARK: - Properties

  private let viewModel: LineSelectorViewModel

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

  public init(viewModel: LineSelectorViewModel) {
    self.viewModel = viewModel
    self.tramPage = LineSelectorPage(viewModel: viewModel.tramPageViewModel)
    self.busPage = LineSelectorPage(viewModel: viewModel.busPageViewModel)
    super.init(transitionStyle: .scroll,
               navigationOrientation: .horizontal,
               options: nil)

    viewModel.setView(view: self)

    // Load views so we can select/deselect cells right away
    self.pages.forEach { _ = $0.view }

    self.delegate = self
    self.dataSource = self

    // Show 1st page as default
    let firstPage = self.pages[0]
    self.setViewControllers([firstPage],
                            direction: .forward,
                            animated: false,
                            completion: nil)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - LineSelectorViewType

  public func setPage(page: LineType, animated: Bool) {
    typealias Direction = UIPageViewController.NavigationDirection

    let pageView: LineSelectorPage
    let direction: UIPageViewController.NavigationDirection

    switch page {
    case .tram:
      pageView = self.tramPage
      direction = .reverse
    case .bus:
      pageView = self.busPage
      direction = .forward
    }

    let selectedPage = self.viewControllers?.first
    if selectedPage !== pageView {
      self.setViewControllers([pageView],
                              direction: direction,
                              animated: animated,
                              completion: nil)
    }
  }

  // MARK: UIPageViewControllerDataSource

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard let index = self.index(of: viewController) else {
      return nil
    }

    let previousIndex = index - 1
    return previousIndex >= 0 ? self.pages[previousIndex] : nil
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let index = self.index(of: viewController) else {
      return nil
    }

    let nextIndex = index + 1
    return nextIndex < self.pages.count ? self.pages[nextIndex] : nil
  }

  private func index(of viewController: UIViewController) -> Int? {
    return self.pages.firstIndex { $0 === viewController }
  }

  // MARK: - UIPageViewControllerDelegate

  public func pageViewController(_ pageViewController:          UIPageViewController,
                                 didFinishAnimating finished:   Bool,
                                 previousViewControllers:       [UIViewController],
                                 transitionCompleted completed: Bool) {
    if completed {
      self.viewModel.viewDidTransitionToPage(page: self.currentPage)
    }
  }
}