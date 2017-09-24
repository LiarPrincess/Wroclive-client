//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class CardPanelInteractiveDismissTransition: UIPercentDrivenInteractiveTransition {

  // MARK: - Properties

  /// are we responsible for dismissal? or is it non-interactive?
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

    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
    self.presentable?.header.addGestureRecognizer(gestureRecognizer)
  }

  // MARK: - Gesture recognizers

  func handlePan(_ gesture: UIPanGestureRecognizer) {
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
