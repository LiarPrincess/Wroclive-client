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

  typealias SectionChangedEvent = Recorded<Event<LineSelectionSection>>

  func simulateSectionEvents(_ events: SectionChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.sectionChanged)
      .disposed(by: self.disposeBag)
  }
}
