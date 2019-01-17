// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

public final class LineSelectorPageViewModel {

  private let disposeBag = DisposeBag()

  // MARK: - Inputs

  public let didSelectIndex:   AnyObserver<IndexPath>
  public let didDeselectIndex: AnyObserver<IndexPath>

  // MARK: - Output

  public let sections:        Driver<[LineSelectorSection]>
  public let selectedIndices: Driver<[IndexPath]>

  // MARK: - Init

  // swiftlint:disable:next function_body_length
  public init(_ store: Store<AppState>, for lineType: LineType) {
    let _didSelectIndex = PublishSubject<IndexPath>()
    self.didSelectIndex = _didSelectIndex.asObserver()

    let _didDeselectIndex = PublishSubject<IndexPath>()
    self.didDeselectIndex = _didDeselectIndex.asObserver()

    self.sections = store.rx.state
      .map { $0.apiData.lines }
      .map { lineResponse -> [Line] in
        switch lineResponse {
        case let .data(lines): return lines
        default: return []
        }
      }
      .map { $0.filter(lineType) }
      .map { LineSelectorSectionCreator.create($0) }
      .startWith([])
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    self.selectedIndices = store.rx.state
      .map { $0.userData.searchCardState.selectedLines }
      .map { $0.filter(lineType) }
      .withLatestFrom(self.sections) { (lines: $0, sections: $1) }
      .map { findIndices(of: $0.lines, in: $0.sections) }
      .startWith([])
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    _didSelectIndex
      .withLatestFrom(self.sections) { (index: $0, sections: $1) }
      .map { getLine(at: $0.index, from: $0.sections) }
      .unwrap()
      .bind { store.dispatch(SearchCardStateAction.selectLine($0)) }
      .disposed(by: self.disposeBag)

    _didDeselectIndex
      .withLatestFrom(self.sections) { (index: $0, sections: $1) }
      .map { getLine(at: $0.index, from: $0.sections) }
      .unwrap()
      .bind { store.dispatch(SearchCardStateAction.deselectLine($0)) }
      .disposed(by: self.disposeBag)
  }
}

private func findIndices(of lines: [Line], in sections: [LineSelectorSection]) -> [IndexPath] {
  // fast path for common case
  guard lines.any else { return [] }

  var indexMap = [Line:IndexPath]()
  for (sectionIndex, section) in sections.enumerated() {
    for (lineIndex, line) in section.items.enumerated() {
      indexMap[line] = IndexPath(item: lineIndex, section: sectionIndex)
    }
  }

  return lines.compactMap { indexMap[$0] }
}

private func getLine(at index: IndexPath, from sections: [LineSelectorSection]) -> Line? {
  guard index.section >= 0
     && index.section < sections.count
    else { return nil }

  let items = sections[index.section].items

  guard index.item >= 0
     && index.item < items.count
    else { return nil }

  return items[index.item]
}
