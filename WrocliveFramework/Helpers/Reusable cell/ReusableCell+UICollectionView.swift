// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// MARK: - Cells

public extension UICollectionView {
  public func registerCell<Cell: AnyObject>(_ : Cell.Type) where Cell: ReusableCell {
    self.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
  }

  public func dequeueCell<Cell: AnyObject>(ofType: Cell.Type, forIndexPath indexPath: IndexPath) -> Cell where Cell: ReusableCell {
    guard let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell
      else { fatalError("Could not dequeue cell of specified type.") }

    return cell
  }
}

// MARK: - Suplementary views

public enum SuplementaryViewKind {
  case header
  case footer

  fileprivate var key: String {
    switch self {
    case .header: return UICollectionElementKindSectionHeader
    case .footer: return UICollectionElementKindSectionFooter
    }
  }
}

public extension UICollectionView {
  public func registerSupplementary<Cell: AnyObject>(_ : Cell.Type, ofKind elementKind: SuplementaryViewKind) where Cell: ReusableCell {
    self.register(Cell.self, forSupplementaryViewOfKind: elementKind.key, withReuseIdentifier: Cell.identifier)
  }

  public func dequeueSupplementary<Cell: AnyObject>(ofType: Cell.Type, kind elementKind: SuplementaryViewKind, for indexPath: IndexPath) -> Cell where Cell: ReusableCell {
    guard let cell = self.dequeueReusableSupplementaryView(ofKind: elementKind.key, withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell
      else { fatalError("Could not dequeue supplementary view of specified type.") }

    return cell
  }
}
