//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit

class CardPanelInteractiveTransition: UIPercentDrivenInteractiveTransition {

  //MARK: - Properties

  var hasStarted = false

  private weak var presentable: CardPanelPresentable!

  //MARK: - Init

  init(for presentable: CardPanelPresentable) {
    self.presentable = presentable
    super.init()

    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
    self.presentable.interactionTarget.addGestureRecognizer(gestureRecognizer)
  }

  //MARK: - Gesture recognizers

  func handleGesture(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: gesture.view)
    let percent = translation.y / self.presentable.contentView.bounds.size.height

    switch gesture.state {
    case .began:
      self.hasStarted = true
      self.presentable.dismiss(animated: true, completion: nil)

    case .changed:
      self.update(percent)

    case .cancelled:
      self.hasStarted = false
      self.cancel()

    case .ended:
      self.hasStarted = false

      let minVelocityToFinish = CardPanelConstants.Interactive.minVelocityToFinish
      let minProgressToFinish = CardPanelConstants.Interactive.minProgressToFinish

      let velocity = gesture.velocity(in: gesture.view).y
      percent > minProgressToFinish || velocity > minVelocityToFinish ? self.finish() : self.cancel()

    default:
      break
    }
  }

}
