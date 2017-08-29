//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = InAppPurchasePresentationConstants.Layout
private typealias Colors       = PresentationControllerConstants.Colors
private typealias Localization = Localizable.Presentation.InAppPurchase

extension InAppPurchasePresentation {

  func initLayout() {
    self.initGradient()
    self.initPages()
    self.initPageViewController()
    self.initPurchaseButton()
    self.initRestorePurchaseLabel()
    self.initPageControl()
  }

  private func initGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame     = self.view.bounds
    gradientLayer.colors    = Colors.Gradient.colors.map { $0.cgColor }
    gradientLayer.locations = Colors.Gradient.locations
    self.view.layer.addSublayer(gradientLayer)
  }

  private func initPages() {
    typealias BookmarksPage = Localization.BookmarksPage
    typealias ColorsPage    = Localization.ColorsPage

    let bookmarksParams = self.createPageParameters(BookmarksPage.image, BookmarksPage.title, BookmarksPage.caption)
    let colorsParams    = self.createPageParameters(ColorsPage.image,    ColorsPage.title,    ColorsPage.caption)

    self.pages = self.createPages([bookmarksParams, colorsParams])
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
      make.left.top.right.equalToSuperview()
    }

    self.pageViewController.didMove(toParentViewController: self)
  }

  private func initPurchaseButton() {
    let attributes = Managers.theme.textAttributes(for: .body, alignment: .center, color: Colors.textPrimary)
    let text = NSAttributedString(string: Localization.upgrade, attributes: attributes)

    self.upgradeButton.setAttributedTitle(text, for: .normal)
    self.upgradeButton.layer.cornerRadius = Layout.UpgradeButton.cornerRadius
    self.upgradeButton.clipsToBounds      = true
    self.upgradeButton.backgroundColor    = Colors.buttonBackground
    self.upgradeButton.contentEdgeInsets  = Layout.UpgradeButton.edgeInsets
    self.upgradeButton.addTarget(self, action: #selector(upgradeButtonPressed), for: .touchUpInside)

    self.view.addSubview(self.upgradeButton)
    self.upgradeButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.pageViewController.view.snp.bottom).offset(Layout.UpgradeButton.topOffset)
    }
  }

  private func initRestorePurchaseLabel() {
    let textAttributes = Managers.theme.textAttributes(for: .caption, alignment: .center, color: Colors.textSecondary)

    var underlineAttributes = textAttributes
    underlineAttributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.styleSingle.rawValue

    let text = NSMutableAttributedString(string: Localization.restoreText, attributes: textAttributes)
    text.append(NSAttributedString(string: " ", attributes: textAttributes))
    text.append(NSAttributedString(string: Localization.restoreLink, attributes: underlineAttributes))
    text.append(NSAttributedString(string: ".", attributes: textAttributes))

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
