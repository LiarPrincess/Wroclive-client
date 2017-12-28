//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct RxSectionModel<TModel: Equatable, TItem: Equatable>: RxSectionType, Equatable {
  let model: TModel
  let items: [TItem]

  init(model: TModel, items: [TItem]) {
    self.model = model
    self.items = items
  }

  static func == (lhs: RxSectionModel<TModel, TItem>, rhs: RxSectionModel<TModel, TItem>) -> Bool {
    return lhs.model == rhs.model
        && lhs.items == rhs.items
  }
}
