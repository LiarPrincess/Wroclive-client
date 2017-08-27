//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Layout       = TutorialPresentationConstants.Layout
private typealias Colors       = PresentationConstants.Colors
private typealias Localization = Localizable.Presentation.Tutorial

extension TutorialPresentation {

  func initLayout() {
//    let imageView = UIImageView(image: #imageLiteral(resourceName: "Test"))

//    self.view.addSubview(imageView)
//    imageView.snp.makeConstraints { make in
//      make.edges.equalToSuperview()
//    }

    self.initGradient()
    self.initPageViewController()
    self.initPageControl()
  }

  private func initGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame     = self.view.bounds
    gradientLayer.colors    = Colors.Gradient.colors.map { $0.cgColor }
    gradientLayer.locations = Colors.Gradient.locations
    self.view.layer.addSublayer(gradientLayer)
  }

  private func initPageViewController() {
    self.initPages()

    self.pageViewController.delegate   = self
    self.pageViewController.dataSource = self
    self.pageViewController.setViewControllers([self.pages[0]], direction: .forward, animated: false, completion: nil)
    self.addChildViewController(self.pageViewController)
    self.view.addSubview(self.pageViewController.view)

    self.pageViewController.view.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.pageViewController.didMove(toParentViewController: self)
  }

  private func initPages() {
    typealias Page0 = Localization.Page0
    typealias Page1 = Localization.Page1
    typealias Page2 = Localization.Page2

    self.pages = [
      TutorialPresentationPage(Page0.image, Page0.title, Page0.caption),
      TutorialPresentationPage(Page1.image, Page1.title, Page1.caption),
      TutorialPresentationPage(Page2.image, Page2.title, Page2.caption)
    ]
  }

  private func initPageControl() {
    self.pageControl.numberOfPages = self.pages.count
    self.pageControl.currentPage   = 0

    self.view.insertSubview(self.pageControl, belowSubview: self.pageViewController.view)
    self.pageControl.snp.makeConstraints { make in
      make.top.equalTo(self.pageViewController.view.snp.bottom).offset(Layout.PageControl.topOffset)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-Layout.PageControl.bottomOffset)
    }
  }
}
