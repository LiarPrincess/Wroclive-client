//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = ThemePresentationConstants.Layout
private typealias Localization = Localizable.Presentation.Theme

extension ThemePresentation {

  func initLayout() {
    self.initGradientSublayer()
    self.initPageViewController()
    self.initPageControl()
  }

  private func initGradientSublayer() {
    self.gradientLayer.frame     = self.view.layer.bounds
    self.gradientLayer.colors    = Managers.theme.colors.presentation.gradient.map { $0.cgColor }
    self.gradientLayer.locations = Managers.theme.colors.presentation.gradientLocations.map { NSNumber(value: $0) }
    self.view.layer.addSublayer(self.gradientLayer)
  }

  private func initPageViewController() {
    self.pageViewController.delegate   = self
    self.pageViewController.dataSource = self
    self.pageViewController.setViewControllers([self.pages[0]], direction: .forward, animated: false, completion: nil)
    self.addChildViewController(self.pageViewController)
    self.view.addSubview(self.pageViewController.view)

    self.pageViewController.view.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.right.equalToSuperview()
    }

    self.pageViewController.didMove(toParentViewController: self)
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
