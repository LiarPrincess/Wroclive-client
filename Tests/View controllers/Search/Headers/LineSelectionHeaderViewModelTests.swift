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

private typealias Localization = Localizable.LineSelection.SectionName
private typealias TextStyles   = LineSelectionHeaderViewConstants.TextStyles

final class LineSelectionHeaderViewModelTests: XCTestCase {

  // MARK: - Properties

  var viewModel:     LineSelectionHeaderViewModel!
  var testScheduler: TestScheduler!
  let disposeBag = DisposeBag()

  // MARK: - Init

  override func setUp() {
    super.setUp()
    self.viewModel     = LineSelectionHeaderViewModel()
    self.testScheduler = TestScheduler(initialClock: 0)
  }

  override func tearDown() {
    super.tearDown()
    self.viewModel     = nil
    self.testScheduler = nil
  }

  // MARK: - Line

  func test_textChanges_onSectionChange() {
    let event0 = next(100, LineSelectionSection(subtype: .regular, lines: []))
    let event1 = next(200, LineSelectionSection(subtype: .night,   lines: []))
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
