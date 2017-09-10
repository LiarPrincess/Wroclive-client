//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ColorSelectionSectionViewModel {
  var name:        String { get }
  var colors:      [AnyColorSelectionSectionColor] { get }
  var colorsCount: Int { get }
}

extension ColorSelectionSectionViewModel {
  var colorsCount: Int { return self.colors.count }
}
