//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LineSelector: UIPageViewController {

  // MARK: - Properties

  private let tramPage = LineSelectorPage()
  private let busPage  = LineSelectorPage()
  private lazy var pages = [self.tramPage, self.busPage]

  private var currentPage: LineType {
    let page = self.viewControllers?.first
    if page === self.tramPage { return .tram }
    if page === self.busPage  { return .bus  }
    fatalError("Invalid page selected")
  }

  private let _pageDidTransition = PublishSubject<LineType>()
  lazy var pageDidTransition: Observable<LineType> = self._pageDidTransition.asObservable()

  lazy var lineSelected: Observable<Line> = {
    let tramSelected = self.tramPage.rx.lineSelected.asObservable()
    let busSelected  = self.busPage .rx.lineSelected.asObservable()
    return Observable.merge(tramSelected, busSelected)
  }()

  lazy var lineDeselected: Observable<Line> = {
    let tramDeselected = self.tramPage.rx.lineDeselected.asObservable()
    let busDeselected  = self.busPage .rx.lineDeselected.asObservable()
    return Observable.merge(tramDeselected, busDeselected)
  }()

  var contentInset: UIEdgeInsets {
    get { return self.tramPage.contentInset }
    set { self.pages.forEach { $0.contentInset = newValue } }
  }

  var scrollIndicatorInsets: UIEdgeInsets {
    get { return self.tramPage.scrollIndicatorInsets }
    set { self.pages.forEach { $0.scrollIndicatorInsets = newValue } }
  }

  var scrollView: UIScrollView {
    switch self.currentPage {
    case .tram: return self.tramPage.scrollView
    case .bus:  return self.busPage .scrollView
    }
  }

  // MARK: - Init

  init() {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    // load views so we can select/deselect cells right away
    self.pages.forEach { _ = $0.view }

    self.delegate   = self
    self.dataSource = self

    self.initLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    // show 1st page as default
    let firstPage = self.pages[0]
    self.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
  }

  // MARK: - Setters

  /// Set current page without invoking Rx observers
  func setPage(_ lineType: LineType, animated: Bool) {
    typealias Direction = UIPageViewControllerNavigationDirection

    let isTram    = lineType == .tram
    let page      = isTram ? self.tramPage     : self.busPage
    let direction = isTram ? Direction.reverse : Direction.forward

    let selectedPage = self.viewControllers?.first
    if selectedPage !== page {
      self.setViewControllers([page], direction: direction, animated: animated, completion: nil)
    }
  }

  /// Set lines without invoking Rx observers
  func setLines(_ lines: [Line], selected selectedLines: [Line]) {
    self.tramPage.setLines(lines.filter(.tram), selected: selectedLines.filter(.tram))
    self.busPage .setLines(lines.filter(.bus),  selected: selectedLines.filter(.bus))
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
      self._pageDidTransition.onNext(self.currentPage)
    }
  }
}
