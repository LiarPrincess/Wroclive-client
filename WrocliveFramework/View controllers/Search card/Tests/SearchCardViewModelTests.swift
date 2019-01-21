// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
import RxCocoa
import RxTest
import ReSwift
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional

private typealias TextStyles = LineSelectorCellConstants.TextStyles

class SearchCardViewModelTests: XCTestCase, ReduxTestCase, RxTestCase, EnvironmentTestCase {

  var viewModel: SearchCardViewModel!

  var store: Store<AppState>!
  var dispatchedActions: [Action]!

  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  var linesObserver:                 TestableObserver<[Line]>!
  var isLineSelectorVisibleObserver: TestableObserver<Bool>!
  var isPlaceholderVisibleObserver:  TestableObserver<Bool>!
  var showAlertObserver:             TestableObserver<SearchCardAlert>!
  var closeObserver:                 TestableObserver<Void>!

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpRx()
    self.setUpEnvironment()

    self.viewModel = SearchCardViewModel(store: self.store)

    typealias Sections = [RxSectionModel<LineSelectorSectionData, Line>]
    let tramSections = self.viewModel.lineSelectorViewModel.busPageViewModel.sections
    let busSections  = self.viewModel.lineSelectorViewModel.tramPageViewModel.sections

    self.self.linesObserver = self.scheduler.createObserver([Line].self)
    Driver.zip(tramSections, busSections)
      .map { (lhs: Sections, rhs: Sections) -> [Line] in
        let lhsLines = lhs.flatMap { $0.items }
        let rhsLines = rhs.flatMap { $0.items }
        return lhsLines + rhsLines
      }
      .drive(self.linesObserver).disposed(by: self.disposeBag)

    self.isLineSelectorVisibleObserver = self.scheduler.createObserver(Bool.self)
    self.viewModel.isLineSelectorVisible.drive(self.isLineSelectorVisibleObserver).disposed(by: self.disposeBag)

    self.isPlaceholderVisibleObserver = self.scheduler.createObserver(Bool.self)
    self.viewModel.isPlaceholderVisible.drive(self.isPlaceholderVisibleObserver).disposed(by: self.disposeBag)

    self.showAlertObserver = self.scheduler.createObserver(SearchCardAlert.self)
    self.viewModel.showAlert.drive(self.showAlertObserver).disposed(by: self.disposeBag)

    self.closeObserver = self.scheduler.createObserver(Void.self)
    self.viewModel.close.drive(self.closeObserver).disposed(by: self.disposeBag)
  }

  override func tearDown() {
    super.tearDown()
    self.tearDownEnvironment()
    self.tearDownRx()
    self.tearDownRedux()
  }

  // MARK: - Data

  lazy var testLines: [Line] = {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name:  "A", type:  .bus, subtype: .regular)
    let line4 = Line(name:  "D", type:  .bus, subtype: .regular)
    return [line0, line1, line2, line3, line4]
  }()

  // MARK: - Events

  typealias LineResponse = ApiResponseState<[Line]>

  func setState(at time: TestTime, _ state: SearchCardState) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.setState { $0.userData.searchCardState = state }
    }
  }

  func setLineResponseState(at time: TestTime, _ response: LineResponse) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.setState { $0.apiData.lines = response }
    }
  }

  func didPressBookmarkButton(at time: TestTime) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didPressBookmarkButton.onNext()
    }
  }

  func didPressSearchButton(at time: TestTime) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didPressSearchButton.onNext()
    }
  }

  func didPressAlertTryAgainButton(at time: TestTime) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didPressAlertTryAgainButton.onNext()
    }
  }

  func didEnterBookmarkName(at time: TestTime, _ value: String) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.didEnterBookmarkName.onNext(value)
    }
  }

  func viewWillAppear(at time: TestTime) {
    self.scheduler.scheduleAt(time) { [unowned self] in
      self.viewModel.viewWillAppear.onNext()
    }
  }
}
