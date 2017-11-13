//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = TutorialPresentationConstants.Layout
private typealias Localization = Localizable.Presentation.Tutorial

extension TutorialPresentation {

  func initLayout() {
    self.initGradientSublayer()
    self.initPages()
    self.initContent()
  }

  private func initGradientSublayer() {
    self.gradientLayer.frame     = self.view.layer.bounds
    self.gradientLayer.colors    = Managers.theme.colors.presentation.gradient.map { $0.cgColor }
    self.gradientLayer.locations = Managers.theme.colors.presentation.gradientLocations.map { NSNumber(value: $0) }
    self.view.layer.addSublayer(self.gradientLayer)
  }

  private func initPages() {
    let page0 = TutorialPresentationPage0()
    let page1 = TutorialPresentationPage1()
    let page2 = TutorialPresentationPage2()

    let pages: [TutorialPresentationPage] = [page0, page1, page2]
    self.guaranteeMinTextHeight(pages)
    self.pages = pages
  }

  private func guaranteeMinTextHeight(_ pages: [TutorialPresentationPage]) {
    let minTextHeight = pages.map { $0.calculateMinTextHeight() }.max() ?? 0.0
    for page in pages {
      page.guaranteeMinTextHeight(minTextHeight)
    }
  }

  private func initContent() {
    // page view controller
    self.pageViewController.delegate   = self
    self.pageViewController.dataSource = self
    self.pageViewController.setViewControllers([self.pages[0]], direction: .forward, animated: false, completion: nil)
    self.addChildViewController(self.pageViewController)
    self.view.addSubview(self.pageViewController.view)

    self.pageViewController.view.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Page.topInset)
      make.left.right.equalToSuperview()
    }

    self.pageViewController.didMove(toParentViewController: self)

    // page control
    self.pageControl.numberOfPages = self.pages.count
    self.pageControl.currentPage   = 0

    self.view.insertSubview(self.pageControl, belowSubview: self.pageViewController.view)
    self.pageControl.snp.makeConstraints { make in
      make.top.equalTo(self.pageViewController.view.snp.bottom).offset(Layout.PageControl.topOffset)
      make.centerX.equalToSuperview()

      let bottomOffset = -Layout.PageControl.bottomOffset
      if #available(iOS 11.0, *) {
        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(bottomOffset)
      }
      else { make.bottom.equalToSuperview().offset(bottomOffset) }
    }
  }
}
