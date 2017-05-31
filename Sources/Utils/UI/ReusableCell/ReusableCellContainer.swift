//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit

//MARK: - ReusableCellContainer

protocol ReusableCellContainer {
  associatedtype CellType

  func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String)
  func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> CellType
}

extension ReusableCellContainer {
  func register<T: AnyObject>(_ : T.Type) where T: ReusableCell {
    register(T.self, forCellWithReuseIdentifier: T.identifier)
  }

  func dequeueReusableCell<T: AnyObject>(ofType: T.Type, forIndexPath indexPath: IndexPath) -> T where T: ReusableCell {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell of specified type.")
    }

    return cell
  }
}

//MARK: - UITableView

extension UITableView: ReusableCellContainer {
  typealias CellType = UITableViewCell

  func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
    self.register(cellClass, forCellReuseIdentifier: identifier)
  }

  func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
    return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
  }
}

//MARK: - UICollectionView

extension UICollectionView: ReusableCellContainer {
  typealias CellType = UICollectionViewCell
}
