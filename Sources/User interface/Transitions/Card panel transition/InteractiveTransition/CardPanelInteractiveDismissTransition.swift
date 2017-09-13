//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class CardPanelInteractiveDismissTransition: UIPercentDrivenInteractiveTransition {

  // MARK: - Properties

  var hasStarted = false

  private weak var presentable: CardPanelPresentable?

  // >= 1.0 will break animation! (reasons unknown)
  override var completionSpeed: CGFloat {
    get { return 0.8 }
    set { }
  }

  // MARK: - Init

  init(for presentable: CardPanelPresentable) {
    self.presentable = presentable
    super.init()

    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
    self.presentable?.interactionTarget.addGestureRecognizer(gestureRecognizer)
  }

  // MARK: - Gesture recognizers

  func handleGesture(gesture: UIPanGestureRecognizer) {
    guard let presentable = self.presentable else { return }

    let translation = gesture.translation(in: gesture.view)
    let percent     = translation.y / presentable.contentView.bounds.height

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

  // MARK: - Methods

  private func shouldFinish(gesture: UIPanGestureRecognizer, completion percent: CGFloat) -> Bool {
    typealias Constants = CardPanelConstants.FinishConditions

    let velocity = gesture.velocity(in: gesture.view).y
    let isUp     = velocity < 0.0

    if  isUp && velocity < -Constants.minVelocityUp   { return false }
    if !isUp && velocity >  Constants.minVelocityDown { return true  }
    return percent > Constants.minProgress
  }
}
