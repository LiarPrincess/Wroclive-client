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

extension Array where Element: RxSectionType {

  subscript(index: IndexPath) -> Element.Item {
    return self[index.section].items[index.item]
  }

  mutating func move(from fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
    let fromSection = self[fromIndexPath.section]

    var fromItems = fromSection.items
    let item = fromItems.remove(at: fromIndexPath.item)
    self[fromIndexPath.section] = Element(model: fromSection.model, items: fromItems)

    let toSection = self[toIndexPath.section]

    var toItems = toSection.items
    toItems.insert(item, at: toIndexPath.item)
    self[toIndexPath.section] = Element(model: toSection.model, items: toItems)
  }

  mutating func remove(at indexPath: IndexPath) {
    let section = self[indexPath.section]
    var items   = section.items
    items.remove(at: indexPath.row)
    self[indexPath.section] = Element(model: section.model, items: items)
  }
}
