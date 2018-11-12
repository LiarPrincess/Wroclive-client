// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

typealias ConstraintMaker = (UIView, UIView) -> NSLayoutConstraint

extension UIView {
  func addSubview(_ view: UIView, constraints: [ConstraintMaker]) {
    self.addSubview(view)
    self.addContraints(view, constraints: constraints)
  }

  func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView, constraints: [ConstraintMaker]) {
    self.insertSubview(view, aboveSubview: siblingSubview)
    self.addContraints(view, constraints: constraints)
  }

  func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView, constraints: [ConstraintMaker]) {
    self.insertSubview(view, belowSubview: siblingSubview)
    self.addContraints(view, constraints: constraints)
  }

  private func addContraints(_ view: UIView, constraints: [ConstraintMaker]) {
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(constraints.map { maker in maker(view, self) })
  }
}

func make(_ viewAnchorPath: KeyPath<UIView, NSLayoutDimension>,
          equalToConstant constant: CGFloat = 0) -> ConstraintMaker {

  return { (view: UIView, _: UIView) in
    let viewAnchor = view[keyPath: viewAnchorPath]
    return viewAnchor.constraint(equalToConstant: constant)
  }
}

func make<Anchor, Axis>(_ viewAnchorPath: KeyPath<UIView, Anchor>,
                        equalToSuperview superviewAnchorPath: KeyPath<UIView, Anchor>,
                        constant: CGFloat = 0) -> ConstraintMaker where Anchor: NSLayoutAnchor<Axis> {

  return { (view: UIView, superview: UIView) in
    let viewAnchor = view[keyPath: viewAnchorPath]
    let superviewAnchor = superview[keyPath: superviewAnchorPath]
    return viewAnchor.constraint(equalTo: superviewAnchor, constant: constant)
  }
}

func make<Anchor, Axis>(_ viewAnchorPath: KeyPath<UIView, Anchor>,
                        equalTo targetAnchor: Anchor,
                        constant: CGFloat = 0) -> ConstraintMaker where Anchor: NSLayoutAnchor<Axis> {

  return { (view: UIView, _: UIView) in
    let viewAnchor = view[keyPath: viewAnchorPath]
    return viewAnchor.constraint(equalTo: targetAnchor, constant: constant)
  }
}

func makeEdgesEqualToSuperview() -> [ConstraintMaker] {
  return [
    make(\UIView.topAnchor, equalToSuperview: \UIView.topAnchor),
    make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor),
    make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor),
    make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
  ]
}
