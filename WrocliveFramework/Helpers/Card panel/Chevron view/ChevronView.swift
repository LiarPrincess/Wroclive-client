// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public final class ChevronView : UIView {

  // MARK: - Properties

  private let leftView  = UIView()
  private let rightView = UIView()

  private var _state = ChevronViewState.flat

  public var state: ChevronViewState {
    get { return self._state }
    set {
      self._state = newValue
      self.updateTransformations(animated: false)
    }
  }

  public var color: UIColor = .white {
    didSet {
      self.leftView.backgroundColor  = self.color
      self.rightView.backgroundColor = self.color
    }
  }

  public var width: CGFloat = 5.0 {
    didSet { self.setNeedsLayout() }
  }

  public var angle: CGFloat = 15.0 {
    didSet { self.setNeedsLayout() }
  }

  public var animationDuration: TimeInterval = 1.0

  /// Proposed size to match Apple 'look and feel'
  public static var nominalSize: CGSize { return CGSize(width: 42, height: 15) }

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

    self.leftView.layer.cornerRadius  = self.width / 2.0
    self.rightView.layer.cornerRadius = self.width / 2.0

    if self._state != .flat {
      self.updateTransformations(animated: false)
    }
  }

  private func calculateFrames() -> (left: CGRect, right: CGRect) {
    let centerX = self.bounds.width / 2.0
    let originY = (self.bounds.height - self.width) / 2.0

    let templateFrame = CGRect(x: 0.0, y: originY, width: centerX, height: self.width)

    // move frames closer together to compensate for rotations
    let dx: CGFloat = centerX * (1.0 - cos(self.angle.rad)) / 2.0

    let leftOffset:  CGFloat = self.width / 2.0 + dx - 1.0
    let rightOffset: CGFloat = centerX - leftOffset

    let leftFrame  = templateFrame.offsetBy(dx:  leftOffset, dy: 0.0)
    let rightFrame = templateFrame.offsetBy(dx: rightOffset, dy: 0.0)
    return (leftFrame, rightFrame)
  }

  // MARK: - Methods

  public func setState(_ state: ChevronViewState, animated: Bool) {
    guard self._state != state else {
      return
    }

    // update backing field instead of property to avoid self.setNeedsLayout
    self._state = state
    self.updateTransformations(animated: animated)
  }

  private func updateTransformations(animated: Bool) {
    let rotateViews = { [weak self] in
      if let strongSelf = self {
        let rotationAngle = strongSelf.angle.rad * CGFloat(strongSelf.state.rawValue)
        strongSelf.leftView.transform  = CGAffineTransform(rotationAngle: -rotationAngle)
        strongSelf.rightView.transform = CGAffineTransform(rotationAngle:  rotationAngle)
      }
    }

    if animated {
      UIView.animate(withDuration: self.animationDuration, animations: rotateViews)
    }
    else {
      UIView.performWithoutAnimation(rotateViews)
    }
  }
}
