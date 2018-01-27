//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class CardPanelInteractiveDismissTransition: UIPercentDrivenInteractiveTransition {

  // MARK: - Properties

  /// Is this class responsible for dismissal? Or is it non-interactive?
  var hasStarted = false

  private weak var presentable: CardPanelPresentable?

  override var completionSpeed: CGFloat {
    get { return 0.8 }
    set { }
  }

  // MARK: - Init

  init(for presentable: CardPanelPresentable) {
    self.presentable = presentable
    super.init()

    let dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(CardPanelInteractiveDismissTransition.handleDismissGesture(_:)))
    dismissGesture.delegate = self
    self.presentable?.header.addGestureRecognizer(dismissGesture)
  }

  // MARK: - Gesture recognizers

  @objc
  func handleDismissGesture(_ gesture: UIPanGestureRecognizer) {
    guard let presentable = self.presentable else { return }

    let mainView    = UIApplication.shared.keyWindow!.rootViewController!.view
    let translation = gesture.translation(in: mainView)
    let percent     = self.clamp(translation.y / presentable.height, min: 0.0, max: 1.0)

    switch gesture.state {
    case .began:
      self.hasStarted = true
      presentable.dismiss(animated: true, completion: nil)

    case .changed:
      self.update(percent)

    case .cancelled:
      self.hasStarted = false
      self.cancel()

    case .ended:
      self.hasStarted = false

      let shouldFinish = self.shouldFinish(gesture: gesture, completion: percent)
      if shouldFinish { self.finish() }
      else            { self.cancel() }

    default:
      break
    }
  }

  // MARK: - Private - Methods

  private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    return Swift.min(Swift.max(value, min), max)
  }

  private func shouldFinish(gesture: UIPanGestureRecognizer, completion percent: CGFloat) -> Bool {
    typealias Conditions = CardPanelConstants.FinishConditions

    let velocity = gesture.velocity(in: gesture.view).y
    let isUp     = velocity < 0.0

    if  isUp && velocity < -Conditions.minVelocityUp   { return false }
    if !isUp && velocity >  Conditions.minVelocityDown { return true  }
    return percent > Conditions.minProgress
  }
}

extension CardPanelInteractiveDismissTransition: UIGestureRecognizerDelegate {

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let gesture    = gestureRecognizer as? UIPanGestureRecognizer,
          let scrollView = self.presentable?.scrollView,
          self.isScrollViewPanGesture(scrollView, otherGestureRecognizer)
      else { return false }

    let isScrollViewAtTop = self.isScrollViewAtTop(scrollView)
    let isScrollingDown   = self.isScrollingDown(gesture)

    let shouldRecognizeSimultaneously = isScrollViewAtTop && isScrollingDown
    if shouldRecognizeSimultaneously {
      scrollView.showsVerticalScrollIndicator = false
      scrollView.bounces = false
      return true
    }

    scrollView.showsVerticalScrollIndicator = true
    scrollView.bounces = true
    return false
  }

  private func isScrollViewPanGesture(_ scrollView: UIScrollView, _ gesture: UIGestureRecognizer) -> Bool {
    return scrollView.panGestureRecognizer === gesture
  }

  private func isScrollViewAtTop(_ scrollView: UIScrollView) -> Bool {
    let scrollOffset = scrollView.contentOffset.y + scrollView.contentInset.top
    return scrollOffset < 0.1
  }

  private func isScrollingDown(_ gesture: UIPanGestureRecognizer) -> Bool {
    let velocity = gesture.velocity(in: gesture.view)
    return velocity.y > 0.0
  }
}
