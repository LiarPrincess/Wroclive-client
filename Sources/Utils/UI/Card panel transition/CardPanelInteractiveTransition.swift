//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class CardPanelInteractiveTransition: UIPercentDrivenInteractiveTransition {

  //MARK: - Properties

  var hasStarted = false

  private weak var presentable: CardPanelPresentable?

  //MARK: - Init

  init(for presentable: CardPanelPresentable) {
    self.presentable = presentable
    super.init()

    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
    self.presentable?.interactionTarget.addGestureRecognizer(gestureRecognizer)
  }

  //MARK: - Gesture recognizers

  func handleGesture(gesture: UIPanGestureRecognizer) {
    guard let presentable = self.presentable else {
      return
    }

    let translation = gesture.translation(in: gesture.view)
    let percent     = translation.y / presentable.contentView.bounds.size.height

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

      if self.shouldFinish(gesture: gesture, completion: percent) {
        self.finish()
      }
      else {
        self.cancel()
      }

    default:
      break
    }
  }

  //MARK: - Methods

  private func shouldFinish(gesture: UIPanGestureRecognizer, completion percent: CGFloat) -> Bool {
    typealias Constants = CardPanelConstants.Interactive

    let velocity = gesture.velocity(in: gesture.view).y
    return percent > Constants.minProgressToFinish || velocity > Constants.minVelocityToFinish
  }

}
