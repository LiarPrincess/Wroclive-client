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

extension LineSelectionCellTests {

  // MARK: - Line

  typealias LineEvent = Recorded<Event<Line>>

  func simulateLineEvents(_ events: LineEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.line)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Is selected

  typealias IsSelectedEvent = Recorded<Event<Bool>>

  func simulateIsSelectedEvents(_ events: IsSelectedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.isSelected)
      .disposed(by: self.disposeBag)
  }
}
