//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = InAppPurchasePresentationConstants.Layout
private typealias Localization = Localizable.Presentation.InAppPurchase

extension InAppPurchasePresentation {

  func initLayout() {
    self.initGradientSublayer()
    self.initPages()
    self.initPageViewController()
    self.initPurchaseButton()
    self.initRestorePurchaseLabel()
    self.initPageControl()
  }

  private func initGradientSublayer() {
    self.gradientLayer.frame     = self.view.layer.bounds
    self.gradientLayer.colors    = Managers.theme.colors.presentation.gradient.map { $0.cgColor }
    self.gradientLayer.locations = Managers.theme.colors.presentation.gradientLocations.map { NSNumber(value: $0) }
    self.view.layer.addSublayer(self.gradientLayer)
  }

  private func initPages() {
    let bookmarksPage = InAppPurchaseBookmarkPage()
    let colorsPage    = InAppPurchaseColorsPage()

    let pages: [InAppPurchasePresentationPage] = [bookmarksPage, colorsPage]
    self.guaranteeMinTextHeight(pages)
    self.pages = pages
  }

  private func guaranteeMinTextHeight(_ pages: [InAppPurchasePresentationPage]) {
    let minTextHeight = pages.map { $0.calculateMinTextHeight() }.max() ?? 0.0
    for page in pages {
      page.guaranteeMinTextHeight(minTextHeight)
    }
  }

  private func initPageViewController() {
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

  private func initPurchaseButton() {
    let attributes = Managers.theme.textAttributes(for: .body, alignment: .center, color: .presentationPrimary)
    let text = NSAttributedString(string: Localization.upgrade, attributes: attributes)

    self.upgradeButton.setAttributedTitle(text, for: .normal)
    self.upgradeButton.layer.cornerRadius = Layout.UpgradeButton.cornerRadius
    self.upgradeButton.clipsToBounds      = true
    self.upgradeButton.backgroundColor    = Managers.theme.colors.presentation.button
    self.upgradeButton.contentEdgeInsets  = Layout.UpgradeButton.edgeInsets
    self.upgradeButton.addTarget(self, action: #selector(upgradeButtonPressed), for: .touchUpInside)

    self.view.addSubview(self.upgradeButton)
    self.upgradeButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.pageViewController.view.snp.bottom).offset(Layout.UpgradeButton.topOffset)
    }
  }

  private func initRestorePurchaseLabel() {
    let textAttributes = Managers.theme.textAttributes(for: .caption, alignment: .center, color: .presentationSecondary)

    var underlineAttributes = textAttributes
    underlineAttributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.styleSingle.rawValue

    let text = NSMutableAttributedString(string: Localization.restoreText, attributes: textAttributes)
    text.append(NSAttributedString(string: " ", attributes: textAttributes))
    text.append(NSAttributedString(string: Localization.restoreLink, attributes: underlineAttributes))
    text.append(NSAttributedString(string: ".", attributes: textAttributes))

    self.restorePurchaseLabel.numberOfLines  = 0
    self.restorePurchaseLabel.attributedText = text
    self.restorePurchaseLabel.isUserInteractionEnabled = true

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(restorePurchaseLabelPressed(tapGestureRecognizer:)))
    restorePurchaseLabel.addGestureRecognizer(tapGesture)

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
