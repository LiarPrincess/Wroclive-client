//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LineSelectionViewModelInput {
  var pageChanged: AnyObserver<LineType> { get }

  var linesChanged:         AnyObserver<[Line]> { get }
  var selectedLinesChanged: AnyObserver<[Line]> { get }
}

protocol LineSelectionViewModelOutput {
  var page: Driver<LineType> { get }

  var tramLines: Driver<[Line]> { get }
  var busLines:  Driver<[Line]> { get }

  var selectedTramLines: Driver<[Line]> { get }
  var selectedBusLines:  Driver<[Line]> { get }
}

class LineSelectionViewModel: LineSelectionViewModelInput, LineSelectionViewModelOutput {

  // MARK: - Properties

  private let _page                 = PublishSubject<LineType>()
  private let _linesChanged         = PublishSubject<[Line]>()
  private let _selectedLinesChanged = PublishSubject<[Line]>()

  // input
  lazy var pageChanged: AnyObserver<LineType> = self._page.asObserver()

  lazy var linesChanged:         AnyObserver<[Line]> = self._linesChanged.asObserver()
  lazy var selectedLinesChanged: AnyObserver<[Line]> = self._selectedLinesChanged.asObserver()

  // output
  let page: Driver<LineType>

  let tramLines: Driver<[Line]>
  let busLines:  Driver<[Line]>

  var selectedTramLines: Driver<[Line]>
  var selectedBusLines:  Driver<[Line]>

  // MARK: - Init

  init() {
    self.page = self._page.asDriver(onErrorDriveWith: .never())

    self.tramLines = self._linesChanged
      .map { filterTrams($0) }
      .asDriver(onErrorJustReturn: [])

    self.busLines = self._linesChanged
      .map { filterBusses($0) }
      .asDriver(onErrorJustReturn: [])

    self.selectedTramLines = self._selectedLinesChanged
      .map { filterTrams($0) }
      .asDriver(onErrorJustReturn: [])

    self.selectedBusLines = self._selectedLinesChanged
      .map { filterBusses($0) }
      .asDriver(onErrorJustReturn: [])
  }

  // MARK: - Input/Output

  var inputs:  LineSelectionViewModelInput  { return self }
  var outputs: LineSelectionViewModelOutput { return self }
}

private func filterTrams(_ lines: [Line]) -> [Line] {
  return lines.filter(.tram)
}

private func filterBusses(_ lines: [Line]) -> [Line] {
  return lines.filter(.bus)
}
