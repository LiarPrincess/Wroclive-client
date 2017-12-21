//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

extension NSAttributedString {
  convenience init(string: String, attributes: TextAttributes) {
    self.init(string: string, attributes: attributes.value)
  }
}
