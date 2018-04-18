//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SettingsCardViewModelInput {
  var mapTypeSelected: AnyObserver<MapType>   { get }
  var itemSelected:    AnyObserver<IndexPath> { get }
}
