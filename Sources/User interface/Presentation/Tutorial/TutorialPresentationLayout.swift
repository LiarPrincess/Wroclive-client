//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Layout       = TutorialPresentationConstants.Layout
private typealias Colors       = PresentationConstants.Colors
//private typealias Localization = Localizable.Presentation.InAppPurchase

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
    let page0Title   = "Wyszukiwanie pojazdów"
    let page0Caption = "By wyszukać pojazdy użyj <search>, wybierz linie, a następnie kliknij “Szukaj”."
    let page0 = TutorialPresentationPage(#imageLiteral(resourceName: "Image_InApp_Colors"), page0Title, page0Caption)

    let page1Title   = "Dodawanie zakładek"
    let page1Caption = "By dodać zakładkę wybierz linie, kliknij <star> i wprowadź nazwę nowej zakładki."
    let page1 = TutorialPresentationPage(#imageLiteral(resourceName: "Image_InApp_Colors"), page1Title, page1Caption)

    let page2Title   = "Zakładki"
    let page2Caption = "Zapisane zakładki są dostępne pod <star>."
    let page2 = TutorialPresentationPage(#imageLiteral(resourceName: "Image_InApp_Colors"), page2Title, page2Caption)

    self.pages = [page0, page1, page2]
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
