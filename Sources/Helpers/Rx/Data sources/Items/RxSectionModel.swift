//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct RxSectionModel<Section: Equatable, Item: Equatable>: RxSectionType, Equatable {
  let model: Section
  let items: [Item]

  init(model: Section, items: [Item]) {
    self.model = model
    self.items = items
  }

  static func == (lhs: RxSectionModel<Section, Item>, rhs: RxSectionModel<Section, Item>) -> Bool {
    return lhs.model == rhs.model
        && lhs.items == rhs.items
  }
}
