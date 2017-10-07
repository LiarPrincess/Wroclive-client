//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol PushCoordinator: Coordinator {
  var pushTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }
}

extension PushCoordinator {
  func presentPush(_ controller: UIViewController, in parent: UIViewController) {
    self.pushTransitionDelegate = PushTransitionDelegate(for: controller)
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate  = self.pushTransitionDelegate
    parent.present(controller, animated: true, completion: nil)
  }
}
