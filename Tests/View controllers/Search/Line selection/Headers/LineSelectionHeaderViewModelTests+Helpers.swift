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

extension LineSelectionHeaderViewModelTests {

  // MARK: - Section

  typealias SectionEvent = Recorded<Event<LineSelectionSection>>

  func simulateSectionEvents(_ events: SectionEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.section)
      .disposed(by: self.disposeBag)
  }
}
