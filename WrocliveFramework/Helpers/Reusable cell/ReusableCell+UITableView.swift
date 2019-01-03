// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// MARK: - Cells

public extension UITableView {
  public func registerCell<Cell: AnyObject>(_ : Cell.Type) where Cell: ReusableCell {
    self.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
  }

  public func dequeueCell<Cell: AnyObject>(ofType: Cell.Type, forIndexPath indexPath: IndexPath) -> Cell where Cell: ReusableCell {
    guard let cell = self.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell
      else { fatalError("Could not dequeue cell of specified type.") }

    return cell
  }
}

// MARK: - Suplementary views

public extension UITableView {
  public func registerSupplementary<Cell: AnyObject>(_ : Cell.Type) where Cell: ReusableCell {
    self.register(Cell.self, forHeaderFooterViewReuseIdentifier: Cell.identifier)
  }

  public func dequeueSupplementary<Cell: AnyObject>(ofType: Cell.Type) -> Cell where Cell: ReusableCell {
    guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: Cell.identifier) as? Cell
      else { fatalError("Could not dequeue supplementary view of specified type.") }

    return cell
  }
}
