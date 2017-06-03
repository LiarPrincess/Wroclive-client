//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

//MARK: - Addition

infix operator &&: AdditionPrecedence

func &&<T> (lhs: @escaping (T) -> Bool, rhs: @escaping (T) -> Bool) -> ((T) -> Bool) {
  return { lhs($0) && rhs($0) }
}
