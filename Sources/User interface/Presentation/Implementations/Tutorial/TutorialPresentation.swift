//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class TutorialPresentation: UIViewController, PresentationController {

  // MARK: - Properties

  let gradientLayer = CAGradientLayer()

  let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  let pageControl        = UIPageControl()
  var pages              = [UIViewController]()

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.gradientLayer.frame = self.view.layer.bounds
  }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension TutorialPresentation: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    return self.viewControllerBefore(viewController)
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    return self.viewControllerAfter(viewController)
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if let selectedPage = self.pageViewController.viewControllers?.first, let index = self.pages.index(of: selectedPage) {
      self.pageControl.currentPage = index
    }
  }
}
