//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

protocol ApplicableAction: Action {
  func apply(state: AppState) -> AppState
}
