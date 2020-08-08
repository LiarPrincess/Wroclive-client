// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension UICollectionView {

  public enum SuplementaryViewKind {
    case header
    case footer

    fileprivate var key: String {
      switch self {
      case .header: return UICollectionView.elementKindSectionHeader
      case .footer: return UICollectionView.elementKindSectionFooter
      }
    }
  }

  public func registerCell<Cell: AnyObject>(_: Cell.Type) where Cell: ReusableCell {
    self.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
  }

  public func dequeueCell<Cell: AnyObject>(
    ofType: Cell.Type,
    forIndexPath indexPath: IndexPath
  ) -> Cell where Cell: ReusableCell {
    let id = Cell.identifier
    let genericCell = self.dequeueReusableCell(withReuseIdentifier: id,
                                               for: indexPath)

    guard let cell = genericCell as? Cell else {
      fatalError("Could not dequeue cell of specified type.")
    }

    return cell
  }

  public func registerSupplementary<Cell: AnyObject>(
    _ : Cell.Type,
    kind: SuplementaryViewKind
  ) where Cell: ReusableCell {
    self.register(Cell.self,
                  forSupplementaryViewOfKind: kind.key,
                  withReuseIdentifier: Cell.identifier)
  }

  public func dequeueSupplementary<Cell: AnyObject>(
    ofType: Cell.Type,
    kind: SuplementaryViewKind,
    for indexPath: IndexPath
  ) -> Cell where Cell: ReusableCell {
    let id = Cell.identifier
    let genericCell = self.dequeueReusableSupplementaryView(
      ofKind: kind.key,
      withReuseIdentifier: id,
      for: indexPath
    )

    guard let cell = genericCell as? Cell else {
      fatalError("Could not dequeue supplementary view of specified type.")
    }

    return cell
  }
}
