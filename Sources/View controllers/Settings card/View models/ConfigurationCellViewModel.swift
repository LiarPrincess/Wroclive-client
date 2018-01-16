//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ConfigurationCellViewModel {
  var text:          String { get }
  var isEnabled:     Bool   { get }
  var accessoryType: UITableViewCellAccessoryType { get }
}

extension ConfigurationCellViewModel {
  var isEnabled:     Bool { return true }
  var accessoryType: UITableViewCellAccessoryType { return .disclosureIndicator }
}
