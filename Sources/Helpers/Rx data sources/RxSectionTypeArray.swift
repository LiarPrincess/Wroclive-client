// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

enum RxSectionOperation {
  case remove(indexPath: IndexPath)
  case move(from: IndexPath, to: IndexPath)
}

extension Array where Element: RxSectionType {

  // MARK: - Subscript

  subscript(index: IndexPath) -> Element.Item {
    return self[index.section].items[index.item]
  }

  // MARK: - Operations

  func apply(_ operation: RxSectionOperation) -> [Element] {
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
}
