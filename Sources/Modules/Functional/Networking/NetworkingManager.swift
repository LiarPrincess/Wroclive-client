//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

protocol NetworkingManager {
  func getLineDefinitions() -> Promise<[Line]>
}
