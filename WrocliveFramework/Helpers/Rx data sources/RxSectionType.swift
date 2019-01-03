// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public protocol RxSectionType: Equatable {
  associatedtype Model: Equatable
  associatedtype Item:  Equatable

  var model: Model  { get }
  var items: [Item] { get }

  init(model: Model, items: [Item])
}
