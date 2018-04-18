//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Result
import RxSwift
import RxCocoa

protocol SearchCardViewModelInput {
  var pageSelected:      AnyObserver<LineType> { get }
  var pageDidTransition: AnyObserver<LineType> { get }

  var lineSelected:   AnyObserver<Line> { get }
  var lineDeselected: AnyObserver<Line> { get }

  var bookmarkButtonPressed: AnyObserver<Void> { get }
  var searchButtonPressed:   AnyObserver<Void> { get }

  var apiAlertTryAgainButtonPressed: AnyObserver<Void>   { get }
  var bookmarkAlertNameEntered:      AnyObserver<String> { get }

  var viewDidAppear:    AnyObserver<Void> { get }
  var viewDidDisappear: AnyObserver<Void> { get }
}
