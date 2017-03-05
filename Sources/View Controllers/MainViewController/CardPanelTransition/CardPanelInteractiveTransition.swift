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

  func wireToViewController(viewController: UIViewController!) {
    self.viewController = viewController

    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
    viewController.view.addGestureRecognizer(gestureRecognizer)
  }

  //MARK: - Gesture recognizers

  func handleGesture(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: gesture.view)
    let percent = translation.y / gesture.view!.bounds.size.height

    switch gesture.state {
    case .began:
      hasStarted = true

      if let _ = viewController as? BookmarksViewController {
        store.dispatch(SetBookmarksVisibility(false))
      }

      if let _ = viewController as? LineSelectionViewController {
        store.dispatch(SetLineSelectionVisibility(false))
      }

//      viewController.dismiss(animated: true, completion: nil)

    case .changed:
      self.update(percent)

    case .cancelled:
      hasStarted = false
      cancel()
      print("cancelled")

    case .ended:
      hasStarted = false

      let velocity = gesture.velocity(in: gesture.view)
      velocity.y > CardPanelConstants.Interactive.minVelocityToFinish ? finish() : cancel()
      print("ended(velocity: \(velocity.y))")

    default:
      break
    }
  }

}
