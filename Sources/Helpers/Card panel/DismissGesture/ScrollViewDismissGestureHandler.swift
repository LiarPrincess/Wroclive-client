// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class ScrollViewDismissGestureHandler: DismissGestureHandler {

  // MARK: - Properties

  var scrollView: UIScrollView { return self.cardPanel.scrollView! }

  /// Why?
  /// If deceleration would force us to lower card, then gesture part would be already finished
  private var observation: NSKeyValueObservation?

  // MARK: - Init

  override init(for cardPanel: CardPanel) {
    super.init(for: cardPanel)

    self.observation = self.scrollView.observe(\.contentOffset, options: [.initial]) { [weak self] _, _ in
      self?.scrollViewDidScroll()
    }
  }

  deinit {
    self.observation = nil
  }

  // MARK: - Handle gesture

  override func handleGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      self.resetGestureStartingPosition(gesture)

    case .changed:
      let offset     = self.calculateOffset(scrollView)
      let isAboveTop = offset <= 0

      if isAboveTop {
        let translation = gesture.translation(in: self.cardView)
        self.updateCardTranslation(movement: translation.y)
        self.dismissIfBelowThreshold(movement: translation.y)
        self.dismissalGestureWillBegin()
      }
      else { self.resetGestureStartingPosition(gesture) }

    case .ended:
      self.moveCardToInitialPosition(animated: true)
      self.cardPanel.dismissalGestureDidEnd()

    default: break
    }
  }

  private func scrollViewDidScroll() {
    let offset     = self.calculateOffset(scrollView)
    let isAboveTop = offset <= 0

    if isAboveTop {
      if self.scrollView.isDecelerating {
        self.moveCardInsteadOfScrollView(offset)
      }
      else { self.scrollView.bounces = false }
    }
    else { self.scrollView.bounces = true }
  }

  private func moveCardInsteadOfScrollView(_ offset: CGFloat) {
    self.cardView.transform = CGAffineTransform(translationX: 0, y: -offset)
    for subview in self.scrollView.subviews {
      subview.transform = CGAffineTransform(translationX: 0, y: offset)
    }
  }

  private func calculateOffset(_ scrollView: UIScrollView) -> CGFloat {
    let base = scrollView.contentOffset.y + scrollView.contentInset.top
    if #available(iOS 11, *) {
      return base + scrollView.safeAreaInsets.top
    }
    else { return base }
  }
}
