//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SettingsCardViewModelInput {
  var itemSelected: AnyObserver<IndexPath> { get }
}
