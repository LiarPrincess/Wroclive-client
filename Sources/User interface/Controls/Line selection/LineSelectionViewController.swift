//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class LineSelectionViewController: UIPageViewController {

  // MARK: - Properties

  weak var selectionDelegate : LineSelectionViewControllerDelegate?

  var selectedLineType: LineType {
    get {
      // note that one of the pages is ALWAYS selected
      let page = self.viewControllers?.first as? LineSelectionPage
      return page == self.tramPage ? .tram : .bus
    }
    set { self.setLineType(newValue, animated: false) }
  }

  var selectedLines: [Line] {
    get { return self.tramPage.selectedLines + self.busPage.selectedLines }
    set {
      self.tramPage.setSelectedLines(newValue.filter { $0.type == .tram })
      self.busPage.setSelectedLines (newValue.filter { $0.type == .bus  })
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

  init(withLines lines: [Line], delegate: LineSelectionViewControllerDelegate? = nil) {
    self.tramPage = LineSelectionPage(withLines: lines.filter { $0.type == .tram })
    self.busPage  = LineSelectionPage(withLines: lines.filter { $0.type == .bus  })

    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    self.dataSource = self
    self.delegate   = self
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

  func setLineType(_ lineType: LineType, animated: Bool) {
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

// MARK: - UIPageViewControllerDelegate

extension LineSelectionViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      self.selectionDelegate?.lineSelectionViewController(controller: self, didChangePage: self.selectedLineType)
    }
  }
}
