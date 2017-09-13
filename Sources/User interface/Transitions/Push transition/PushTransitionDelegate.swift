//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = PushConstants

class PushTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

  // MARK: - Properties

  private let interactiveDismissTransition: PushInteractiveDismissTransition

  // MARK: - Init

  init(for viewController: UIViewController) {
    self.interactiveDismissTransition = PushInteractiveDismissTransition(for: viewController)
    super.init()
  }

  // MARK: - Transition

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PushPresentationTransition(Constants.AnimationDuration.present)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return PushDismissTransition(Constants.AnimationDuration.dismiss)
  }
}
