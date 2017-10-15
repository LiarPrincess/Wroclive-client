//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ThemePresentation: UIViewController, PresentationController, HasThemeManager {

  typealias Dependencies = HasThemeManager

  // MARK: - Properties

  let managers: Dependencies
  var theme:    ThemeManager    { return self.managers.theme }

  let gradientLayer = CAGradientLayer()

  let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  let pageControl        = UIPageControl()

  let page0 = ThemePresentationPage()
  let page1 = ThemePresentationPage()
  lazy var pages: [UIViewController] = { return [self.page0, self.page1] }()

  // MARK: - Init

  convenience init(managers: Dependencies) {
    self.init(nibName: nil, bundle: nil, managers: managers)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, managers: Dependencies) {
    self.managers = managers
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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

extension ThemePresentation: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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
