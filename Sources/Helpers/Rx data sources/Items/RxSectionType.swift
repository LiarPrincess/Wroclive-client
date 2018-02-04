//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol RxSectionType: Equatable {
  associatedtype Model: Equatable
  associatedtype Item:  Equatable

  var model: Model  { get }
  var items: [Item] { get }

  init(model: Model, items: [Item])
}
