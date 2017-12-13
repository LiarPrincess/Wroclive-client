//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// MARK: - ReusableSuplementaryViewContainer

enum SuplementaryViewKind {
  case header
  case footer

  fileprivate var key: String {
    switch self {
    case .header: return UICollectionElementKindSectionHeader
    case .footer: return UICollectionElementKindSectionFooter
    }
  }
}

protocol ReusableSuplementaryViewContainer {
  func register(_ viewClass: Swift.AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String)
  func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView
}

extension ReusableSuplementaryViewContainer {
  func registerSupplementary<T: AnyObject>(_ : T.Type, ofKind elementKind: SuplementaryViewKind) where T: ReusableCell {
    register(T.self, forSupplementaryViewOfKind: elementKind.key, withReuseIdentifier: T.identifier)
  }

  func dequeueReusableSupplementaryView<T: AnyObject>(ofType: T.Type, kind elementKind: SuplementaryViewKind, for indexPath: IndexPath) -> T where T: ReusableCell {
    guard let cell = dequeueReusableSupplementaryView(ofKind: elementKind.key, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell of specified type.")
    }

    return cell
  }
}

// MARK: - UICollectionView

extension UICollectionView: ReusableSuplementaryViewContainer { }
