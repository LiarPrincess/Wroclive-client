//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol CardPanelCoordinator: Coordinator {
  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }
}

extension CardPanelCoordinator {
  func presentCardPanel<TCardPanel>(_ cardPanel: TCardPanel, in viewController: UIViewController)
    where TCardPanel: UIViewController, TCardPanel: CardPanelPresentable
  {
    self.cardPanelTransitionDelegate = CardPanelTransitionDelegate(for: cardPanel)
    cardPanel.modalPresentationStyle = .custom
    cardPanel.transitioningDelegate  = self.cardPanelTransitionDelegate!
    viewController.present(cardPanel, animated: true, completion: nil)
  }
}
