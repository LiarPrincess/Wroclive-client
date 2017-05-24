//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

//MARK: - CardPanelPresentable

protocol CardPanelPresentable: class {
  var contentView: UIView { get }
  var interactionTarget: UIView { get }

  func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
}
