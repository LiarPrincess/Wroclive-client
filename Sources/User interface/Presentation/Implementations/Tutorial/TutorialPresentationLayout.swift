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
    typealias Page0 = Localization.Page0
    typealias Page1 = Localization.Page1
    typealias Page2 = Localization.Page2

    let page0 = self.createPageParameters(Page0.image, Page0.title, Page0.caption)
    let page1 = self.createPageParameters(Page1.image, Page1.title, Page1.caption)
    let page2 = self.createPageParameters(Page2.image, Page2.title, Page2.caption)
    self.pages = PresentationControllerPageFactory.create([page0, page1, page2])
  }

  func createPageParameters(_ image: UIImage, _ title: String, _ caption: String) -> PresentationControllerPageParameters {
    typealias PageLayout = Layout.Page
    let view = UIView()
    view.backgroundColor = UIColor.red
    view.alpha = 0.5

    return PresentationControllerPageParameters(
      view:    view,
      title:   title,   titleTopOffset:   PageLayout.Title.topOffset,
      caption: caption, captionTopOffset: PageLayout.Caption.topOffset,
      leftOffset: Layout.leftOffset, rightOffset: Layout.rightOffset
    )
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
      make.bottom.equalToSuperview().offset(-Layout.PageControl.bottomOffset)
    }
  }
}
