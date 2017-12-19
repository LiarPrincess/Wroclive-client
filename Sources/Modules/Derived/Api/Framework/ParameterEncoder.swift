//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import Alamofire

protocol ParameterEncoder {
  associatedtype ParameterData
  static func encode(_ data: ParameterData) -> Parameters?
}

class EmptyParameterEncoder: ParameterEncoder {
  typealias ParameterData = Void

  static func encode(_ data: ParameterData) -> Parameters? {
    return nil
  }
}
