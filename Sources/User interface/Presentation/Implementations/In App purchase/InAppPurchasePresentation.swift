//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class InAppPurchasePresentation: UIViewController, PresentationController {

  typealias Dependencies = HasAppStoreManager

  // MARK: - Properties

  let managers: Dependencies

  let gradientLayer = CAGradientLayer()

  let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  let pageControl        = UIPageControl()
  var pages              = [UIViewController]()

  let upgradeButton        = UIButton(type: .roundedRect)
  let restorePurchaseLabel = UILabel()

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

  // MARK: - Actions

  @objc func upgradeButtonPressed() {
    self.managers.appstore.buyUpgrade()
  }

  @objc func restorePurchaseLabelPressed(tapGestureRecognizer: UITapGestureRecognizer) {
    self.managers.appstore.restorePurchase()
  }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension InAppPurchasePresentation: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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
