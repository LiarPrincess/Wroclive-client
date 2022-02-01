// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Constants = CardContainer.Constants.DismissGesture

internal final class ScrollViewDismissGestureHandler: DismissGestureHandler {

  // MARK: - Properties

  private let scrollView: UIScrollView

  // Why?
  // If deceleration would force us to lower card, then gesture would
  // be already finished, so we need 'something'.
  private var observation: NSKeyValueObservation?

  // MARK: - Init

  internal init(card: CardContainer, scrollView: UIScrollView) {
    self.scrollView = scrollView
    super.init(card: card)

    // swiftlint:disable:next trailing_closure
    self.observation = self.scrollView.observe(
      \.contentOffset,
      options: [.initial],
      changeHandler: { [weak self] _, _ in self?.disableScrollingWhenAboveTop() }
    )
  }

  private func disableScrollingWhenAboveTop() {
    let offset = self.calculateScrollViewOffset()
    let isAboveTop = offset <= 0

    let isScrollingDisabled = isAboveTop && !self.scrollView.isDecelerating
    self.scrollView.bounces = !isScrollingDisabled
  }

  deinit {
    self.observation = nil
  }

  // MARK: - Handle gesture

  override internal func handleGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      self.resetGestureStartingPosition(gesture)
      self.notifyInteractiveDismissalWillBegin()

    case .changed:
      let offset = self.calculateScrollViewOffset()
      // Did we scroll so much that the white background above the scroll view
      // is showing?
      let isScrollViewAboveTop = offset <= 0

      if isScrollViewAboveTop {
        let translation = gesture.translation(in: self.card.view)
        self.updateCardTranslation(movement: translation.y)
        self.dismissIfBelowThreshold(movement: translation.y)

        let percent = translation.y / Constants.dismissThreshold
        self.notifyInteractiveDismissalProgress(percent: percent)
      } else {
        self.resetGestureStartingPosition(gesture)
      }

    // Ended means that user lifted their finger without dismissing
    case .ended:
      self.moveCardToInitialPosition(animated: true)
      self.notifyInteractiveDismissalDidEnd(completed: false)

    // Cancelled means that gesture was interrupted in the middle
    // (for example by dismiss)
    case .cancelled:
      self.notifyInteractiveDismissalDidEnd(completed: true)

    default:
      break
    }
  }

  private func calculateScrollViewOffset() -> CGFloat {
    let contentOffset = self.scrollView.contentOffset.y
    let contentInset = self.scrollView.contentInset.top
    let safeAreaInsets = self.scrollView.safeAreaInsets.top
    return contentOffset + contentInset + safeAreaInsets
  }
}
