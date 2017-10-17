//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class LineSelectionViewController: UIPageViewController {

  // MARK: - Properties

  var currentPage: LineType {
    get {
      // note that one of the pages is ALWAYS selected
      let page = self.viewControllers?.first as? LineSelectionPage
      return page == self.tramPage ? .tram : .bus
    }
    set { self.setCurrentPage(newValue, animated: false) }
  }

  var lines: [Line] {
    get { return self.tramPage.lines + self.busPage.lines }
    set {
      self.tramPage.lines = newValue.filter(.tram)
      self.busPage.lines  = newValue.filter(.bus )
    }
  }

  var selectedLines: [Line] {
    get { return self.tramPage.selectedLines + self.busPage.selectedLines }
    set {
      self.tramPage.selectedLines = newValue.filter(.tram)
      self.busPage.selectedLines  = newValue.filter(.bus )
    }
  }

  var contentInset: UIEdgeInsets {
    get { return self.tramPage.contentInset }
    set {
      self.tramPage.contentInset = newValue
      self.busPage.contentInset  = newValue
    }
  }

  var scrollIndicatorInsets: UIEdgeInsets {
    get { return self.tramPage.scrollIndicatorInsets }
    set {
      self.tramPage.scrollIndicatorInsets = newValue
      self.busPage.scrollIndicatorInsets  = newValue
    }
  }

  fileprivate let tramPage: LineSelectionPage
  fileprivate let busPage:  LineSelectionPage

  fileprivate lazy var pages: [LineSelectionPage] = {
    return [self.tramPage, self.busPage]
  }()

  // MARK: - Init

  init(withLines lines: [Line]) {
    self.tramPage = LineSelectionPage(withLines: lines.filter(.tram))
    self.busPage  = LineSelectionPage(withLines: lines.filter(.bus))

    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    // load view so we can select/deselect cells right away
    self.pages.forEach { _ = $0.view }
    self.dataSource = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setViewControllers([self.tramPage], direction: .forward, animated: false, completion: nil)
  }

  // MARK: - Methods

  func setCurrentPage(_ lineType: LineType, animated: Bool) {
    typealias Direction = UIPageViewControllerNavigationDirection

    let isTram    = lineType == .tram
    let page      = isTram ? self.tramPage     : self.busPage
    let direction = isTram ? Direction.reverse : Direction.forward

    self.setViewControllers([page], direction: direction, animated: animated, completion: nil)
  }
}

// MARK: UIPageViewControllerDataSource

extension LineSelectionViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = self.pages.index(of: viewController as! LineSelectionPage) else {
      return nil
    }

    let previousIndex = index - 1
    return previousIndex >= 0 ? self.pages[previousIndex] : nil
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = self.pages.index(of: viewController as! LineSelectionPage) else {
      return nil
    }

    let nextIndex = index + 1
    return nextIndex < self.pages.count ? self.pages[nextIndex] : nil
  }
}
