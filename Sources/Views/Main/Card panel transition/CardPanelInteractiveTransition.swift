//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

class CardPanelInteractiveTransition: UIPercentDrivenInteractiveTransition {

  //MARK: - Properties

  var hasStarted = false

  private weak var viewController: UIViewController!

  //MARK: - Init

  init(for viewController: UIViewController) {
    self.viewController = viewController
    super.init()

    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
    self.viewController.view.addGestureRecognizer(gestureRecognizer)
  }

  //MARK: - Gesture recognizers

  func handleGesture(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: gesture.view)
    let percent = translation.y / gesture.view!.bounds.size.height

    switch gesture.state {
    case .began:
      self.hasStarted = true
      self.viewController.dismiss(animated: true, completion: nil)

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
