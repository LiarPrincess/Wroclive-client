// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Wroclive

// swiftlint:disable implicitly_unwrapped_optional

private typealias TextStyles = LineSelectorCellConstants.TextStyles

class SearchCardViewModelTests: TestCase {

  var viewModel: SearchCardViewModel!

  var pageObserver:                  TestableObserver<LineType>!
  var linesObserver:                 TestableObserver<[Line]>!
  var selectedLinesObserver:         TestableObserver<[Line]>!
  var isLineSelectorVisibleObserver: TestableObserver<Bool>!
  var isPlaceholderVisibleObserver:  TestableObserver<Bool>!
  var showAlertObserver:             TestableObserver<SearchCardAlert>!
  var startTrackingObserver:         TestableObserver<[Line]>!

  func initViewModel() {
    self.viewModel = SearchCardViewModel()

    self.pageObserver = self.scheduler.createObserver(LineType.self)
    self.viewModel.page.drive(self.pageObserver).disposed(by: self.disposeBag)

    self.linesObserver = self.scheduler.createObserver([Line].self)
    self.viewModel.lines.drive(self.linesObserver).disposed(by: self.disposeBag)

    self.selectedLinesObserver = self.scheduler.createObserver([Line].self)
    self.viewModel.selectedLines.drive(self.selectedLinesObserver).disposed(by: self.disposeBag)

    self.isLineSelectorVisibleObserver = self.scheduler.createObserver(Bool.self)
    self.viewModel.isLineSelectorVisible.drive(self.isLineSelectorVisibleObserver).disposed(by: self.disposeBag)

    self.isPlaceholderVisibleObserver = self.scheduler.createObserver(Bool.self)
    self.viewModel.isPlaceholderVisible.drive(self.isPlaceholderVisibleObserver).disposed(by: self.disposeBag)

    self.showAlertObserver = self.scheduler.createObserver(SearchCardAlert.self)
    self.viewModel.showAlert.drive(self.showAlertObserver).disposed(by: self.disposeBag)

    self.startTrackingObserver = self.scheduler.createObserver([Line].self)
    self.viewModel.startTracking.drive(self.startTrackingObserver).disposed(by: self.disposeBag)
  }

  // MARK: - Data

  var testData: [Line] {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name:  "A", type:  .bus, subtype: .regular)
    let line4 = Line(name:  "D", type:  .bus, subtype: .regular)
    return [line0, line1, line2, line3, line4]
  }

  // MARK: - Events

  func mockPageSelected(at time: TestTime, _ value: LineType) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.didSelectPage.onNext(value)
    }
  }

  func mockPageTransition(at time: TestTime, _ value: LineType) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.didTransitionToPage.onNext(value)
    }
  }

  func mockLineResponse(at time: TestTime, _ value: Single<[Line]>) {
    self.apiManager.mockAvailableLineResponse(at: time, value)
  }

  func mockTryAgainButtonPressed(at time: TestTime) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.didPressAlertTryAgainButton.onNext()
    }
  }

  func mockSelectedLine(at time: TestTime, _ value: Line) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.didSelectLine.onNext(value)
    }
  }

  func mockDeselectedLine(at time: TestTime, _ value: Line) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.didDeselectLine.onNext(value)
    }
  }

  func mockBookmarkButtonPressed(at time: TestTime) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.didPressBookmarkButton.onNext()
    }
  }

  func mockBookmarkAlertNameEntered(at time: TestTime, _ value: String) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.didEnterBookmarkName.onNext(value)
    }
  }

  func mockSearchButtonPressed(at time: TestTime) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.didPressSearchButton.onNext()
    }
  }

  func mockViewDidAppear(at time: TestTime) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.viewDidAppear.onNext()
    }
  }

  func mockViewDidDisappear(at time: TestTime) {
    self.scheduler.scheduleAt(time) {
      self.viewModel.viewDidDisappear.onNext()
    }
  }
}
