// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit
import CoreGraphics

// MARK: - CGFloat + Radian

extension CGFloat {

  // Convert to radian
  public var rad: CGFloat {
    return self * CGFloat.pi / 180.0
  }
}

// MARK: - UIApplication + Top view controller

extension UIApplication {

  public static var topViewController: UIViewController {
    guard var result = UIApplication.shared.keyWindow?.rootViewController
      else { fatalError("Could not find top view controller.") }

    var child = result.presentedViewController
    while child != nil {
      result = child! // swiftlint:disable:this force_unwrapping
      child = result.presentedViewController
    }

    return result
  }
}

// MARK: - UISegmentedControl

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

// MARK: - UICollectionView

extension UICollectionView {

  /// `bounds.width - self.contentInset`
  public var contentWidth: CGFloat {
    return self.bounds.width - self.contentInset.left - self.contentInset.right
  }
}

// MARK: - UIView

extension UIView {

  public func setContentHuggingPriority(_ priority: Float,
                                        for axis: NSLayoutConstraint.Axis) {
    self.setContentHuggingPriority(UILayoutPriority(priority), for: axis)
  }
}

// MARK: - UIView + Round corners

extension UIView {

  public func roundTopCorners(radius: CGFloat) {
    self.roundCorners([.topLeft, .topRight], radius: radius)
  }

  public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let cornerRadii = CGSize(width: radius, height: radius)
    let maskPath = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: cornerRadii)

    let maskLayer = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path  = maskPath.cgPath

    self.layer.mask = maskLayer
  }
}

// MARK: - UIView + Add border

extension UIView {

  private var borderColor: UIColor {
    return Theme.colors.accentLight
  }

  public func addTopBorder(device: DeviceManagerType) {
    let view = UIView()
    view.backgroundColor = self.borderColor

    let width = self.onePixel(device: device)

    self.addSubview(view)
    view.snp.makeConstraints { make in
      make.height.equalTo(width)
      make.top.left.right.equalToSuperview()
    }
  }

  public func addBottomBorder(device: DeviceManagerType) {
    let view = UIView()
    view.backgroundColor = self.borderColor

    let width = self.onePixel(device: device)

    self.addSubview(view)
    view.snp.makeConstraints { make in
      make.height.equalTo(width)
      make.bottom.left.right.equalToSuperview()
    }
  }

  private func onePixel(device: DeviceManagerType) -> CGFloat {
    return CGFloat(1.0) / device.screenScale
  }
}
