//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class PushInteractiveDismissTransition: UIPercentDrivenInteractiveTransition {

  // MARK: - Properties

  var hasStarted = false

  private weak var viewController: UIViewController?

  override var completionSpeed: CGFloat {
    get { return 0.8 }
    set { }
  }

  // MARK: - Init

  init(for viewController: UIViewController) {
    self.viewController = viewController
    super.init()

    let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
    gestureRecognizer.edges = [.left]
    self.viewController?.view.addGestureRecognizer(gestureRecognizer)
  }

  // MARK: - Gesture recognizers

  @objc
  func handleGesture(gesture: UIPanGestureRecognizer) {
    guard let viewController = self.viewController else { return }

    switch gesture.state {
    case .began:
      self.hasStarted = true
      viewController.dismiss(animated: true, completion: nil)

    case .cancelled, .ended:
      self.hasStarted = false
      self.finish()

    default:
      break
    }
  }
}
