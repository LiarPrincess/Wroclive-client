//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

final class BookmarkViewModelTests: XCTestCase {

  // MARK: - Properties

  private var viewModel:     BookmarksViewModel!
  private var testScheduler: TestScheduler!
  private let disposeBag = DisposeBag()

  // MARK: Init

  override func setUp() {
    super.setUp()
    self.viewModel     = BookmarksViewModel()
    self.testScheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    super.tearDown()
    self.viewModel     = nil
    self.testScheduler = nil
  }

  // MARK: - Test - Edit

  func test_isEditingChanges_onEditClick() {
    let event0 = EditClickEvent(time: 100)
    let event1 = EditClickEvent(time: 200)
    self.simulateEditClickEvents(event0, event1)

    let observer = self.testScheduler.createObserver(Bool.self)
    self.viewModel.outputs.isEditing
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let expectedEvents = [next(0, false), next(100, true), next(200, false)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func test_editButtonTextChanges_onEditClick() {
    let event0 = EditClickEvent(time: 100)
    let event1 = EditClickEvent(time: 200)
    self.simulateEditClickEvents(event0, event1)

    let observer = self.testScheduler.createObserver(NSAttributedString.self)
    self.viewModel.outputs.editButtonText
      .drive(observer)
      .disposed(by: self.disposeBag)
    self.testScheduler.start()

    let editString = Localizable.Bookmarks.Edit.edit
    let doneString = Localizable.Bookmarks.Edit.done
    let expectedEvents = [next(0, editString), next(100, doneString), next(200, editString)]
    XCTAssertEqual(self.toStringEvents(observer.events), expectedEvents)
  }

  // MARK: - Helper - Events

  private struct EditClickEvent {
    let time: TestTime

    var recordedEvent: Recorded<Event<Void>> {
      return next(self.time, ())
    }
  }

  private func simulateEditClickEvents(_ events: EditClickEvent...) {
    let recordedEvents = events.map { $0.recordedEvent }
    let observable = testScheduler.createHotObservable(recordedEvents)
    observable
      .bind(to: self.viewModel.inputs.editButtonPressed)
      .disposed(by: self.disposeBag)
  }

  private func toStringEvents(_ events: [Recorded<Event<NSAttributedString>>]) -> [Recorded<Event<String>>] {
    return events.map { next($0.time, $0.value.element!.string) }
  }
}
