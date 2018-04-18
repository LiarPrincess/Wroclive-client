//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BookmarksCardViewModelInput {
  var itemSelected: AnyObserver<IndexPath>      { get }
  var itemMoved:    AnyObserver<ItemMovedEvent> { get }
  var itemDeleted:  AnyObserver<IndexPath>      { get }

  var editButtonPressed: AnyObserver<Void> { get }
}
