//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = TutorialPresentationConstants.Layout
private typealias Colors       = PresentationControllerConstants.Colors
private typealias Localization = Localizable.Presentation.Tutorial

extension TutorialPresentation {

  func initLayout() {
    self.initGradient()
    self.initPages()
    self.initPageViewController()
    self.initPageControl()
    self.initBackButton()
  }

  private func initGradient() {
    self.gradientLayer.frame     = self.view.layer.bounds
    self.gradientLayer.colors    = Colors.Gradient.colors.map { $0.cgColor }
    self.gradientLayer.locations = Colors.Gradient.locations
    self.view.layer.addSublayer(self.gradientLayer)
  }

  private func initPages() {
    typealias Page0 = Localization.Page0
    typealias Page1 = Localization.Page1
    typealias Page2 = Localization.Page2

    let page0 = self.createPageParameters(Page0.image, Page0.title, Page0.caption)
    let page1 = self.createPageParameters(Page1.image, Page1.title, Page1.caption)
    let page2 = self.createPageParameters(Page2.image, Page2.title, Page2.caption)
    self.pages = self.createPages([page0, page1, page2])
  }

  func createPageParameters(_ image: UIImage, _ title: String, _ caption: String) -> PresentationControllerPageParams {
    typealias PageLayout = Layout.Page
    return PresentationControllerPageParams(
      image, title, caption,
      Layout.leftOffset, Layout.rightOffset,
      PageLayout.Title.topOffset,
      PageLayout.Caption.topOffset, PageLayout.Caption.lineSpacing
    )
  }

  private func initPageViewController() {
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

  private func initBackButton() {
    typealias ButtonLayout = Layout.BackButton

    let backImage = StyleKit.drawBackTemplateImage(size: ButtonLayout.imageSize)

    let button = UIButton()
    button.setImage(backImage, for: .normal)
    button.addTarget(self, action: #selector(TutorialPresentation.closeButtonPressed), for: .touchUpInside)
    button.contentEdgeInsets = UIEdgeInsets(top: ButtonLayout.topInset, left: ButtonLayout.leftInset, bottom: ButtonLayout.bottomInset, right: ButtonLayout.rightInset)

    self.view.addSubview(button)
    button.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
    }
  }
}
