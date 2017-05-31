//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit

//MARK: - ReusableSuplementaryViewContainer

protocol ReusableSuplementaryViewContainer {
  func register(_ viewClass: Swift.AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String)
  func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView
}

extension ReusableSuplementaryViewContainer {
  func registerSupplementary<T: AnyObject>(_ : T.Type, ofKind elementKind: String) where T: ReusableCell {
    register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.identifier)
  }

  func dequeueReusableSupplementaryView<T: AnyObject>(ofType: T.Type, kind elementKind: String, for indexPath: IndexPath) -> T where T: ReusableCell {
    guard let cell = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell of specified type.")
    }

    return cell
  }
}

//MARK: - UICollectionView

extension UICollectionView: ReusableSuplementaryViewContainer { }
