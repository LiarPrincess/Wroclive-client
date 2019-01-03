// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public struct RxSectionModel<Section: Equatable, Item: Equatable>: RxSectionType, Equatable {
  public let model: Section
  public let items: [Item]

  public init(model: Section, items: [Item]) {
    self.model = model
    self.items = items
  }

  public static func == (lhs: RxSectionModel<Section, Item>, rhs: RxSectionModel<Section, Item>) -> Bool {
    return lhs.model == rhs.model
        && lhs.items == rhs.items
  }
}
