//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Result
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Wroclive

class SearchCardViewModelLinesTests: SearchCardViewModelTestsBase {

  func test_didAppear_updatesLines() {
    self.viewModel = SearchCardViewModel()

    let lines = self.testLines
    self.simulateViewDidAppearEvents(at: 100)
    self.simulateApiLinesEvents(next(200, .success(lines)))

    let observers = self.bindObserters()
    self.testScheduler.start()

    XCTAssertEqual(observers.lines.events,                 [next(0, []), next(200, lines)])
    XCTAssertEqual(observers.showAlert.events,           [])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false), next(200, true)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true),  next(200, false)])
    XCTAssertOperationCount(self.apiManager, availableLines: 1)
  }

  func test_didAppear_withoutLines_showsAlert() {
    self.viewModel = SearchCardViewModel()

    let lines = [Line]()
    self.simulateViewDidAppearEvents(at: 100)
    self.simulateApiLinesEvents(next(200, .success(lines)))

    let observers = self.bindObserters()
    self.testScheduler.start()

    XCTAssertEqual(observers.lines.events,                 [next(0, [])])
    XCTAssertEqual(observers.showAlert.events,           [next(200, .apiError(error: .generalError))])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true)])
    XCTAssertOperationCount(self.apiManager, availableLines: 1)
  }

  func test_didAppear_withoutInternet_showsAlert() {
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidAppearEvents(at: 100)
    self.simulateApiLinesEvents(next(200, .failure(ApiError.noInternet)))

    let observers = self.bindObserters()
    self.testScheduler.start()

    XCTAssertEqual(observers.lines.events,                 [next(0, [])])
    XCTAssertEqual(observers.showAlert.events,           [next(200, .apiError(error: .noInternet))])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true)])
    XCTAssertOperationCount(self.apiManager, availableLines: 1)
  }

  func test_didAppear_withApiError_showsAlert() {
    self.viewModel = SearchCardViewModel()

    self.simulateViewDidAppearEvents(at: 100)
    self.simulateApiLinesEvents(next(200, .failure(ApiError.generalError)))

    let observers = self.bindObserters()
    self.testScheduler.start()

    XCTAssertEqual(observers.lines.events,                 [next(0, [])])
    XCTAssertEqual(observers.showAlert.events,           [next(200, .apiError(error: .generalError))])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true)])
    XCTAssertOperationCount(self.apiManager, availableLines: 1)
  }

  func test_closingApiAlert_delays_andUpdatesLines() {
    self.viewModel = SearchCardViewModel()

    let lines = self.testLines
    self.simulateTryAgainButtonPressedEvents(at: 100)
    self.simulateApiLinesEvents(next(200, .success(lines)))

    let observers = self.bindObserters()
    self.testScheduler.start()

    XCTAssertEqual(observers.lines.events,                  [next(0, []), next(200, lines)])
    XCTAssertEqual(observers.showAlert.events,           [])
    XCTAssertEqual(observers.isLineSelectorVisible.events, [next(0, false), next(200, true)])
    XCTAssertEqual(observers.isPlaceholderVisible.events,  [next(0, true),  next(200, false)])
    XCTAssertOperationCount(self.apiManager, availableLines: 1)
  }

  private struct Observers {
    let lines:                 TestableObserver<[Line]>
    let showAlert:             TestableObserver<SearchCardAlert>
    let isLineSelectorVisible: TestableObserver<Bool>
    let isPlaceholderVisible:  TestableObserver<Bool>
  }

  private func bindObserters() -> Observers {
    let linesObserver = self.testScheduler.createObserver([Line].self)
    self.viewModel.lines
      .drive(linesObserver)
      .disposed(by: self.disposeBag)

    let showAlertObserver = self.testScheduler.createObserver(SearchCardAlert.self)
    self.viewModel.showAlert
      .drive(showAlertObserver)
      .disposed(by: self.disposeBag)

    let isLineSelectorVisibleObserver = self.testScheduler.createObserver(Bool.self)
    self.viewModel.isLineSelectorVisible
      .drive(isLineSelectorVisibleObserver)
      .disposed(by: self.disposeBag)

    let isPlaceholderVisibleObserver = self.testScheduler.createObserver(Bool.self)
    self.viewModel.isPlaceholderVisible
      .drive(isPlaceholderVisibleObserver)
      .disposed(by: self.disposeBag)

    return Observers(lines:                 linesObserver,
                     showAlert:             showAlertObserver,
                     isLineSelectorVisible: isLineSelectorVisibleObserver,
                     isPlaceholderVisible:  isPlaceholderVisibleObserver)
  }
}
