//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class TutorialPresentation: UIViewController {

  // MARK: - Properties

  let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  let pageControl        = UIPageControl()
  var pages              = [UIViewController]()

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  // MARK: - Actions

  @objc func closeButtonPressed() {

  }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension TutorialPresentation: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = self.pages.index(of: viewController) else { return nil }
    let previousIndex = index - 1
    return previousIndex >= 0 ? self.pages[previousIndex] : nil
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = self.pages.index(of: viewController) else { return nil }
    let nextIndex = index + 1
    return nextIndex < self.pages.count ? self.pages[nextIndex] : nil
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if let selectedPage = self.pageViewController.viewControllers?.first, let index = self.pages.index(of: selectedPage) {
      self.pageControl.currentPage = index
    }
  }
}
