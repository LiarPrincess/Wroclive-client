//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Foundation
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

extension LineSelectionCellViewModelTests {

  // MARK: - Line

  typealias LineChangedEvent = Recorded<Event<Line>>

  func simulateLineEvents(_ events: LineChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.lineChanged)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Is selected

  typealias IsSelectedChangedEvent = Recorded<Event<Bool>>

  func simulateIsSelectedEvents(_ events: IsSelectedChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.isSelectedChanged)
      .disposed(by: self.disposeBag)
  }
}
