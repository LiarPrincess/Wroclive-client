//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ChevronView : UIView {

  // MARK: - Properties

  private let leftView  = UIView()
  private let rightView = UIView()

  private var _state = ChevronViewState.flat

  var state: ChevronViewState {
    get { return self._state }
    set {
      self._state = newValue
      self.updateTransformations(animated: false)
    }
  }

  var color: UIColor = .white {
    didSet {
      self.leftView.backgroundColor  = self.color
      self.rightView.backgroundColor = self.color
    }
  }

  var width: CGFloat = 5.0 {
    didSet { self.setNeedsLayout() }
  }

  var angle: CGFloat = 15.0 {
    didSet { self.setNeedsLayout() }
  }

  var animationDuration: TimeInterval = 1.0

  /// Proposed size to match Apple 'look and feel'
  static var nominalSize: CGSize { return CGSize(width: 42, height: 15) }

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.isUserInteractionEnabled = false

    self.addSubview(self.leftView)
    self.addSubview(self.rightView)
    self.leftView.backgroundColor  = self.color
    self.rightView.backgroundColor = self.color
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override func layoutSubviews() {
    super.layoutSubviews()

    let centerX = self.bounds.width / 2.0
    let originY = (self.bounds.height - self.width) / 2.0

    var leftFrame  = CGRect(x: 0.0, y: originY, width: centerX, height: self.width)
    var rightFrame = leftFrame.offsetBy(dx: centerX, dy: 0.0)

    // move views closer together to compensate for rotations
    let dx = leftFrame.size.width * (1 - cos(self.angle.rad)) / 2.0
    leftFrame  =  leftFrame.offsetBy(dx:  self.width / 2.0 + dx - 1.0, dy: 0.0)
    rightFrame = rightFrame.offsetBy(dx: -self.width / 2.0 - dx + 1.0, dy: 0.0)

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

  // MARK: - Methods

  func setState(_ state: ChevronViewState, animated: Bool) {
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
