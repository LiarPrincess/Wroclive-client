// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout             = CardPanelConstants.Layout
private typealias AnimationDurations = CardPanelConstants.AnimationDurations

class CardPanel: UIViewController {

  // MARK: - Properties

  let chevronView          = ChevronView()
  let chevronViewContainer = UIView()

  var height: CGFloat { return 0.5 * AppEnvironment.device.screenBounds.height }

  var scrollView: UIScrollView? { return nil }

  var presentationDuration: TimeInterval { return AnimationDurations.present }
  var dismissalDuration:    TimeInterval { return AnimationDurations.dismiss }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.roundTopCorners()
    self.addChevronView()
  }

  private func roundTopCorners() {
    self.view.roundTopCorners(radius: Layout.topCornerRadius)
  }

  private func addChevronView() {
    self.view.addSubview(self.chevronViewContainer, constraints: [
      make(\UIView.topAnchor, equalToSuperview: \UIView.topAnchor),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])

    self.chevronView.state = .down
    self.chevronView.color = Theme.colors.accentLight
    self.chevronView.animationDuration = 0.1

    self.chevronViewContainer.addSubview(self.chevronView, constraints: [
      make(\UIView.topAnchor, equalToSuperview: \UIView.topAnchor, constant: 8.0),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor),
      make(\UIView.centerXAnchor, equalToSuperview: \UIView.centerXAnchor),
      make(\UIView.widthAnchor, equalToConstant: ChevronView.nominalSize.width),
      make(\UIView.heightAnchor, equalToConstant: ChevronView.nominalSize.height)
    ])
  }

  // MARK: - Presentation

  func presentationWillBegin() { }
  func presentationDidEnd()    { }

  // MARK: - Dismiss gesture

  func dismissalGestureWillBegin() {
    self.chevronView.setState(.flat, animated: true)
  }

  func dismissalGestureDidEnd() {
    self.chevronView.setState(.down, animated: true)
  }
}
