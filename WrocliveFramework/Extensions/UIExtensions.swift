// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit
import CoreGraphics

// MARK: - UIColor

extension UIColor {

  public convenience init(light: UIColor, dark: UIColor) {
    if #available(iOS 13.0, *) {
      self.init { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light,
             .unspecified: return light
        case .dark: return dark
        @unknown default: return light
        }
      }
    } else {
      self.init(cgColor: light.cgColor)
    }
  }
}

// MARK: - CGFloat + Radian

extension CGFloat {

  // Convert to radian
  public var rad: CGFloat {
    return self * CGFloat.pi / 180.0
  }
}

// MARK: - UIApplication + topViewController

extension UIApplication {

  public static var topViewController: UIViewController {
    guard var result = UIApplication.shared.keyWindow?.rootViewController else {
      fatalError("Could not get 'keyWindow.rootViewController'.")
    }

    var child = result.presentedViewController
    while child != nil {
      result = child! // swiftlint:disable:this force_unwrapping
      child = result.presentedViewController
    }

    return result
  }
}

// MARK: - UISegmentedControl + font

extension UISegmentedControl {

  private var fontKey: NSAttributedString.Key {
    return NSAttributedString.Key.font
  }

  public var font: UIFont {
    // swiftlint:disable:next force_cast
    get { return self.titleTextAttributes(for: .normal)?[self.fontKey] as! UIFont }
    set { self.setTitleTextAttributes([self.fontKey: newValue as Any], for: .normal) }
  }
}

// MARK: - UICollectionView + contentWidth

extension UICollectionView {

  /// `bounds.width - self.contentInset`
  public var contentWidth: CGFloat {
    return self.bounds.width - self.contentInset.left - self.contentInset.right
  }
}

// MARK: - UITraitCollection + hasChangedUserInterfaceStyle

extension UITraitCollection {

  @available(iOS 12.0, *)
  public func hasChangedUserInterfaceStyle(
    comparedTo traitCollection: UITraitCollection?
  ) -> Bool {
    let current = self.userInterfaceStyle
    let old = traitCollection?.userInterfaceStyle
    return current != old
  }
}

// MARK: - UIView + setContentHuggingPriority

extension UIView {

  public func setContentHuggingPriority(_ priority: Float,
                                        for axis: NSLayoutConstraint.Axis) {
    self.setContentHuggingPriority(UILayoutPriority(priority), for: axis)
  }
}

// MARK: - UIView + roundCorners

extension UIView {

  public func roundTopCorners(radius: CGFloat) {
    self.roundCorners([.topLeft, .topRight], radius: radius)
  }

  public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let maskFrame = self.bounds

    // If we already have mask with correct size then abort.
    if let currentMask = self.layer.mask, currentMask.frame == maskFrame {
      return
    }

    let cornerRadii = CGSize(width: radius, height: radius)
    let maskPath = UIBezierPath(roundedRect: maskFrame,
                                byRoundingCorners: corners,
                                cornerRadii: cornerRadii)

    let maskLayer = CAShapeLayer()
    maskLayer.frame = maskFrame
    maskLayer.path = maskPath.cgPath
    self.layer.mask = maskLayer
  }
}

// MARK: - UIView + addBorder

extension UIView {

  private var onePixel: CGFloat {
    let scale = UIScreen.main.scale
    return CGFloat(1.0) / scale
  }

  private var borderColor: UIColor {
    return ColorScheme.accent
  }

  public func addTopBorder() {
    let view = UIView()
    view.backgroundColor = self.borderColor

    self.addSubview(view)
    view.snp.makeConstraints { make in
      make.height.equalTo(self.onePixel)
      make.top.left.right.equalToSuperview()
    }
  }

  public func addBottomBorder() {
    let view = UIView()
    view.backgroundColor = self.borderColor

    self.addSubview(view)
    view.snp.makeConstraints { make in
      make.height.equalTo(self.onePixel)
      make.bottom.left.right.equalToSuperview()
    }
  }
}

// MARK: - UIViewController + insetScrollView

extension UIViewController {

  /// Modify `scrollView.contentInset.top` so that `scrollView`
  /// content is below given `minTopInsetView`.
  ///
  /// It assumes that `scrollView.frame.minY == minTopInsetView.frame.minY`.
  func inset(scrollView: UIScrollView, below otherView: UIView) {
    let minTopInset = otherView.bounds.height

    // safeAreaInsets - The insets that you use to determine the safe area
    // for this view.
    let safeAreaInsets = self.view.safeAreaInsets.top
    // contentInset - The custom distance that the content view is inset
    // from the safe area or scroll view edges.
    let contentInset = scrollView.contentInset.top
    // adjustedContentInset - The insets derived from the content insets
    // and the safe area of the scroll view.
    let adjustedContentInset = safeAreaInsets + contentInset

    let additionalTopInset = minTopInset - adjustedContentInset
    if additionalTopInset > 0 {
      scrollView.contentInset.top += additionalTopInset
      scrollView.scrollIndicatorInsets.top += additionalTopInset

      // We added inset, but that means that the top 'additionalTopInset' points
      // are now invisible -> we need to scroll up by 'additionalTopInset' points.
      // (If you want to test it then comment following lines and run on iPhone X).
      var offset = scrollView.contentOffset
      offset.y -= additionalTopInset
      scrollView.setContentOffset(offset, animated: false)
    }
  }
}
