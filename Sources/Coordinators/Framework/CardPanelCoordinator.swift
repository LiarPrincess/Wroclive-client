//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

protocol CardPanelCoordinator: Coordinator {
  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }
}

extension CardPanelCoordinator {
  func presentCardPanel<TCardPanel: UIViewController & CardPanelPresentable>
      (_ cardPanel: TCardPanel, in viewController: UIViewController, animated: Bool) {
    self.cardPanelTransitionDelegate = CardPanelTransitionDelegate(for: cardPanel)
    cardPanel.modalPresentationStyle = .custom
    cardPanel.transitioningDelegate  = self.cardPanelTransitionDelegate!
    viewController.present(cardPanel, animated: animated, completion: nil)
  }
}
