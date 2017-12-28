//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LineSelectionPageViewModelInput {
  var linesChanged:         AnyObserver<[Line]> { get }
  var selectedLinesChanged: AnyObserver<[Line]> { get }
}

protocol LineSelectionPageViewModelOutput {
  var sections:      Driver<[LineSelectionSection]> { get }
  var selectedLines: Driver<[Line]>                 { get }
}

class LineSelectionPageViewModel: LineSelectionPageViewModelInput, LineSelectionPageViewModelOutput {

  // MARK: - Properties

  private let _linesChanged         = PublishSubject<[Line]>()
  private let _selectedLinesChanged = PublishSubject<[Line]>()

  // input
  lazy var linesChanged:         AnyObserver<[Line]> = self._linesChanged.asObserver()
  lazy var selectedLinesChanged: AnyObserver<[Line]> = self._selectedLinesChanged.asObserver()

  // output
  let sections:      Driver<[LineSelectionSection]>
  let selectedLines: Driver<[Line]>

  // MARK: - Init

  init() {
    self.sections = self._linesChanged
      .map(toSections)
      .asDriver(onErrorJustReturn: [])

    self.selectedLines = self._selectedLinesChanged
      .asDriver(onErrorJustReturn: [])
  }

  // MARK: - Input/Output

  var inputs:  LineSelectionPageViewModelInput  { return self }
  var outputs: LineSelectionPageViewModelOutput { return self }
}

// MARK: - Items

private func toSections(_ lines: [Line]) -> [LineSelectionSection] {
  return lines
    .groupedBy { $0.subtype }
    .map { createSection(subtype: $0, lines: $1) }
    .sorted { getOrder(subtype: $0.model.lineSubtype) < getOrder(subtype: $1.model.lineSubtype) }
}

private func createSection(subtype lineSubtype: LineSubtype, lines: [Line]) -> LineSelectionSection {
  let data = LineSelectionSectionData(for: lineSubtype)
  return LineSelectionSection(model: data, items: lines.sorted(by: .name))
}

private func getOrder(subtype lineSubtype: LineSubtype) -> Int {
  switch lineSubtype {
  case .express:   return 0
  case .regular:   return 1

  case .night:     return 2
  case .suburban:  return 3

  case .peakHour:  return 4
  case .zone:      return 5
  case .limited:   return 6
  case .temporary: return 7
  }
}
