// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Constants = CardPanelConstants.DismissGesture

internal final class ScrollViewDismissGestureHandler: DismissGestureHandler {

  // MARK: - Properties

  private let scrollView: UIScrollView

  // Why? If deceleration would force us to lower card, then gesture part would
  // be already finished
  private var observation: NSKeyValueObservation?

  // MARK: - Init

  internal init(for presentedViewController: UIViewController,
                scrollView: UIScrollView) {
    self.scrollView = scrollView
    super.init(for: presentedViewController)

    self.observation = self.scrollView.observe(
      \.contentOffset,
      options: [.initial]
    ) { [weak self] _, _ in
      self?.scrollViewDidScroll()
    }
  }

  deinit {
    self.observation = nil
  }

  // MARK: - Handle gesture

  internal override func handleGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      self.resetGestureStartingPosition(gesture)
      self.notifyInteractiveDismissalWillBegin()

    case .changed:
      let offset = self.calculateScrollViewOffset(scrollView)
      let isScrollViewAboveTop = offset <= 0

      if isScrollViewAboveTop {
        let translation = gesture.translation(in: self.presentedView)
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

    default: break
    }
  }

  private func scrollViewDidScroll() {
    let offset = self.calculateScrollViewOffset(scrollView)
    let isAboveTop = offset <= 0

    let isScrollingDisabled = isAboveTop && !self.scrollView.isDecelerating
    self.scrollView.bounces = !isScrollingDisabled
  }

  private func calculateScrollViewOffset(_ scrollView: UIScrollView) -> CGFloat {
    let base = scrollView.contentOffset.y + scrollView.contentInset.top
    return base + scrollView.safeAreaInsets.top
  }
}
