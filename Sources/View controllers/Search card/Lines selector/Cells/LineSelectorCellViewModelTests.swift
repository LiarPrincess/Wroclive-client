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

private typealias TextStyles = LineSelectorCellConstants.TextStyles

final class LineSelectorCellViewModelTests: XCTestCase {

  // MARK: - Properties

  var viewModel:     LineSelectorCellViewModel!
  var testScheduler: TestScheduler!
  let disposeBag = DisposeBag()

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.viewModel     = LineSelectorCellViewModel()
    self.testScheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    super.tearDown()
    self.viewModel     = nil
    self.testScheduler = nil
  }

  // MARK: - Line

  func test_changingLine_updatesText() {
    let event0 = next(100, Line(name: "0l", type: .tram, subtype: .regular))
    let event1 = next(200, Line(name:  "a", type:  .bus, subtype: .express))
    self.simulateLineEvents(event0, event1)

    let observer = self.testScheduler.createObserver(NSAttributedString.self)
    self.viewModel.outputs.text
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, NSAttributedString(string:   "", attributes: TextStyles.notSelected)),
      next(100, NSAttributedString(string: "0L", attributes: TextStyles.notSelected)),
      next(200, NSAttributedString(string:  "A", attributes: TextStyles.notSelected))
    ]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  // MARK: - IsSelected

  func test_changingSelection_updatesText() {
    self.simulateIsSelectedEvents(next(100, true), next(200, false))

    let observer = self.testScheduler.createObserver(NSAttributedString.self)
    self.viewModel.outputs.text
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [
      next(  0, NSAttributedString(string: "", attributes: TextStyles.notSelected)),
      next(100, NSAttributedString(string: "", attributes: TextStyles.selected)),
      next(200, NSAttributedString(string: "", attributes: TextStyles.notSelected))
    ]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}

// MARK: - Events

extension LineSelectorCellViewModelTests {

  // MARK: - Line

  typealias LineChangedEvent = Recorded<Event<Line>>

  func simulateLineEvents(_ events: LineChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.line)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Is selected

  typealias IsSelectedChangedEvent = Recorded<Event<Bool>>

  func simulateIsSelectedEvents(_ events: IsSelectedChangedEvent...) {
    testScheduler.createHotObservable(events)
      .bind(to: self.viewModel.inputs.isSelected)
      .disposed(by: self.disposeBag)
  }
}
