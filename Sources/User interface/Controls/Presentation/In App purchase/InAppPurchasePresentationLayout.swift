//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants    = InAppPurchasePresentationConstants
private typealias Layout       = Constants.Layout
private typealias Colors       = Constants.Colors
private typealias Localization = Constants.Localization

extension InAppPurchasePresentation {

  func initLayout() {
    self.initGradient()
    self.initPageViewController()
    self.initPurchaseButton()
    self.initRestorePurchaseLabel()
    self.initPageControl()
  }

  private func initGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame     = self.view.bounds
    gradientLayer.colors    = Colors.Gradient.colors.map { return $0.cgColor }
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
    typealias BookmarksPage = Localization.BookmarksPage
    typealias ColorsPage    = Localization.ColorsPage

    let bookmarksPage = InAppPurchasePresentationPage(BookmarksPage.image, BookmarksPage.title, BookmarksPage.caption)
    let colorsPage    = InAppPurchasePresentationPage(ColorsPage.image,    ColorsPage.title,    ColorsPage.caption)

    self.pages = [bookmarksPage, colorsPage]
  }

  private func initPurchaseButton() {
    let attributes = Managers.theme.textAttributes(for: .body, alignment: .center, color: .background)
    let text = NSAttributedString(string: Localization.upgrade, attributes: attributes)

    self.upgradeButton.setAttributedTitle(text, for: .normal)
    self.upgradeButton.layer.cornerRadius = Layout.UpgradeButton.cornerRadius
    self.upgradeButton.clipsToBounds      = true
    self.upgradeButton.backgroundColor    = Colors.UpgradeButton.background
    self.upgradeButton.contentEdgeInsets  = Layout.UpgradeButton.edgeInsets
    self.upgradeButton.addTarget(self, action: #selector(upgradeButtonPressed), for: .touchUpInside)

    self.view.addSubview(self.upgradeButton)
    self.upgradeButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.pageViewController.view.snp.bottom).offset(Layout.UpgradeButton.topOffset)
    }
  }

  private func initRestorePurchaseLabel() {
    let attributes = Managers.theme.textAttributes(for: .caption, alignment: .center, color: .backgroundAccent)
    self.restorePurchaseLabel.attributedText = NSAttributedString(string: Localization.restore, attributes: attributes)

    self.view.addSubview(self.restorePurchaseLabel)
    self.restorePurchaseLabel.snp.makeConstraints { make in
      make.top.equalTo(self.upgradeButton.snp.bottom).offset(Layout.RestoreLabel.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }
  }

  private func initPageControl() {
    self.pageControl.numberOfPages = self.pages.count
    self.pageControl.currentPage   = 0

    self.view.insertSubview(self.pageControl, belowSubview: self.restorePurchaseLabel)
    self.pageControl.snp.makeConstraints { make in
      make.top.equalTo(self.restorePurchaseLabel.snp.bottom).offset(Layout.PageControl.topOffset)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-Layout.PageControl.bottomOffset)
    }
  }
}
