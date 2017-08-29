//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol PresentationController {
  var pageViewController: UIPageViewController { get }
  var pageControl:        UIPageControl        { get }
  var pages:              [UIViewController]   { get }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension PresentationController {
  func viewControllerBefore(_ viewController: UIViewController) -> UIViewController? {
    guard let index = self.pages.index(of: viewController) else { return nil }
    let previousIndex = index - 1
    return previousIndex >= 0 ? self.pages[previousIndex] : nil
  }

  func viewControllerAfter(_ viewController: UIViewController) -> UIViewController?  {
    guard let index = self.pages.index(of: viewController) else { return nil }
    let nextIndex = index + 1
    return nextIndex < self.pages.count ? self.pages[nextIndex] : nil
  }
}

// MARK: - Page creation

extension PresentationController {
  func createPages(_ parameters: [PresentationControllerPageParams]) -> [PresentationControllerPage] {
    let pages = parameters.map { PresentationControllerPage($0) }

    let minTextHeight = pages.map { $0.calculateRequiredTextHeight() }.max() ?? 0.0
    for page in pages {
      page.guaranteeMinTextHeight(minTextHeight)
    }

    return pages
  }
}
