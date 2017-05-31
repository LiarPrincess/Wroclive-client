//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit

//MARK: - CardPanelPresentable

protocol CardPanelPresentable: class {
  var contentView:       UIView { get }
  var interactionTarget: UIView { get }

  func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
}
