//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import Foundation

enum RxCollectionOperation {
  case remove(indexPath: IndexPath)
  case move(from: IndexPath, to: IndexPath)
}

extension Array where Element: RxSectionType {

// MARK: - Subscript

  subscript(index: IndexPath) -> Element.Item {
    return self[index.section].items[index.item]
  }

  // MARK: - Operations

  func apply(_ operation: RxCollectionOperation) -> [Element] {
    var copy = self
    switch operation {
    case let .remove(index):  copy.remove(at: index)
    case let .move(from, to): copy.move(from: from, to: to)
    }
    return copy
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

  // MARK: - Content

  func hasItems() -> Bool {
    return !hasNoItems()
  }

  func hasNoItems() -> Bool {
    let firstNotEmpty = self.first { $0.items.any }
    return firstNotEmpty == nil
  }
}
