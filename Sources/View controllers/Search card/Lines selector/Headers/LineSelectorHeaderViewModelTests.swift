//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

private typealias Localization = Localizable.Search.Sections
private typealias TextStyles   = LineSelectorHeaderViewConstants.TextStyles

final class LineSelectorHeaderViewModelTests: XCTestCase {

  // MARK: - Properties

  var viewModel:     LineSelectorHeaderViewModel!
  var testScheduler: TestScheduler!
  let disposeBag = DisposeBag()

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.viewModel     = LineSelectorHeaderViewModel()
    self.testScheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    super.tearDown()
    self.viewModel     = nil
    self.testScheduler = nil
  }

  // MARK: - Line

  func test_changingSection_updatesText() {
    let event0 = next(100, LineSelectorSection(model: LineSelectorSectionData(for: .regular), items: []))
    let event1 = next(200, LineSelectorSection(model: LineSelectorSectionData(for: .night),   items: []))
    self.simulateSectionEvents(event0, event1)

    let observer = self.testScheduler.createObserver(NSAttributedString.self)
    self.viewModel.outputs.text
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(100, NSAttributedString(string: Localization.regular, attributes: TextStyles.header)),
      next(200, NSAttributedString(string: Localization.night,   attributes: TextStyles.header))
    ]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}

// MARK: - Events

extension LineSelectorHeaderViewModelTests {

  // MARK: - Section

  typealias SectionEvent = Recorded<Event<LineSelectorSection>>

  func simulateSectionEvents(_ events: SectionEvent...) {
    self.testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.section)
      .disposed(by: self.disposeBag)
  }
}
