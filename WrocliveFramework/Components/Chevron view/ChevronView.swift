// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum ChevronViewState: Int {
  case up   =  1
  case flat =  0
  case down = -1
}

public final class ChevronView : UIView {

  // MARK: - Properties

  private let leftView  = UIView()
  private let rightView = UIView()

  private var _angle: CGFloat = 0.0

  /// Current angle between chevron arms in degrees
  public var angle: CGFloat {
    get { return self._angle }
    set {
      let newAngle = self.clamp(newValue, min: -ChevronView.maxAngle, max: ChevronView.maxAngle)
      let angleDiff = (newAngle - angle).magnitude

      if angleDiff > 0.2 {
        self._angle = newAngle
        self.updateTransformations()
      }
    }
  }

  public var color: UIColor = .white {
    didSet {
      self.leftView.backgroundColor  = self.color
      self.rightView.backgroundColor = self.color
    }
  }

  /// Width of an single arm
  public static let width: CGFloat = 5.0

  /// Maximum angle between arms
  public static let maxAngle: CGFloat = 15.0

  /// Proposed size to match Apple 'look and feel'
  public static var nominalSize: CGSize = CGSize(width: 42, height: 15)

  // MARK: - Init

  public override init(frame: CGRect) {
    super.init(frame: frame)

    self.isUserInteractionEnabled = false

    self.addSubview(self.leftView)
    self.addSubview(self.rightView)
    self.leftView.backgroundColor  = self.color
    self.rightView.backgroundColor = self.color

    // see: https://stackoverflow.com/a/32579709
    self.leftView.layer.allowsEdgeAntialiasing = true
    self.rightView.layer.allowsEdgeAntialiasing = true
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  public override func layoutSubviews() {
    super.layoutSubviews()

    let (leftFrame, rightFrame) = self.calculateFrames()

    self.leftView.bounds  = leftFrame
    self.rightView.bounds = rightFrame

    self.leftView.center  = CGPoint(x: leftFrame.midX,  y: leftFrame.midY)
    self.rightView.center = CGPoint(x: rightFrame.midX, y: leftFrame.midY)

    self.leftView.layer.cornerRadius  = ChevronView.width / 2.0
    self.rightView.layer.cornerRadius = ChevronView.width / 2.0

    self.updateTransformations()
  }

  private func calculateFrames() -> (left: CGRect, right: CGRect) {
    let centerX = self.bounds.width / 2.0
    let originY = (self.bounds.height - ChevronView.width) / 2.0

    let templateFrame = CGRect(x: 0.0, y: originY, width: centerX, height: ChevronView.width)

    // move frames closer together to compensate for rotations
    // otherwise we would end up with gap between arms
    let dx: CGFloat = centerX * (1.0 - cos(ChevronView.maxAngle.rad)) / 2.0

    let leftOffset:  CGFloat = ChevronView.width / 2.0 + dx - 1.0
    let rightOffset: CGFloat = centerX - leftOffset

    let leftFrame  = templateFrame.offsetBy(dx:  leftOffset, dy: 0.0)
    let rightFrame = templateFrame.offsetBy(dx: rightOffset, dy: 0.0)
    return (leftFrame, rightFrame)
  }

  // MARK: - Methods

  public func setState(_ state: ChevronViewState) {
    self.angle = ChevronView.maxAngle * CGFloat(state.rawValue)
  }

  // MARK: - Helpers

  private func clamp(_ x: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat.maximum(CGFloat.minimum(x, max), min)
  }

  private func updateTransformations() {
    UIView.performWithoutAnimation { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.leftView.transform  = CGAffineTransform(rotationAngle: -strongSelf.angle.rad)
      strongSelf.rightView.transform = CGAffineTransform(rotationAngle:  strongSelf.angle.rad)
    }
  }
}
