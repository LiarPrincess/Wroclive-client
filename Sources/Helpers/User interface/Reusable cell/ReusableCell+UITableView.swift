//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// MARK: - Cells

extension UITableView {
  func registerCell<Cell: AnyObject>(_ : Cell.Type) where Cell: ReusableCell {
    self.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
  }

  func dequeueCell<Cell: AnyObject>(ofType: Cell.Type, forIndexPath indexPath: IndexPath) -> Cell where Cell: ReusableCell {
    guard let cell = self.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell
      else { fatalError("Could not dequeue cell of specified type.") }

    return cell
  }
}

// MARK: - Suplementary views

extension UITableView {
  func registerSupplementary<Cell: AnyObject>(_ : Cell.Type) where Cell: ReusableCell {
    self.register(Cell.self, forHeaderFooterViewReuseIdentifier: Cell.identifier)
  }

  func dequeueSupplementary<Cell: AnyObject>(ofType: Cell.Type) -> Cell where Cell: ReusableCell {
    guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: Cell.identifier) as? Cell
      else { fatalError("Could not dequeue supplementary view of specified type.") }

    return cell
  }
}
