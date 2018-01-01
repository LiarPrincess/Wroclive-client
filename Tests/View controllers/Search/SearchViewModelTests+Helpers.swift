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

extension SearchViewModelTests {

  // MARK: - Page

  typealias LineTypeSelectorPageChangedEvent = Recorded<Event<LineType>>
  typealias LineSelectorPageChangedEvent     = Recorded<Event<LineType>>

  func simulateLineTypeSelectorPageChangedEvents(_ events: LineTypeSelectorPageChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.lineTypeSelectorPageChanged)
      .disposed(by: self.disposeBag)
  }

  func simulateLineSelectorPageChangedEvents(_ events: LineSelectorPageChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.lineSelectorPageChanged)
      .disposed(by: self.disposeBag)
  }
}
