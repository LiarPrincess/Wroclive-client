// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
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
  public init(linesProp:         Observable<[Line]>,
              selectedLinesProp: Observable<[Line]>,
              onLineSelected:    @escaping (Line) -> (),
              onLineDeselected:  @escaping (Line) -> ()) {

    let _didSelectIndex = PublishSubject<IndexPath>()
    self.didSelectIndex = _didSelectIndex.asObserver()

    let _didDeselectIndex = PublishSubject<IndexPath>()
    self.didDeselectIndex = _didDeselectIndex.asObserver()

    self.sections = linesProp
      .map(LineSelectorSectionCreator.create)
      .startWith([])
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .never())

    // because of how UICollectionView works we need re-post selectedIndices every time lines change
    // do not use .distinctUntilChanged(), if the lines changed then probably `selectedLines` have not
    let indicesAfterLinesChanged = self.sections.asObservable()
      .withLatestFrom(selectedLinesProp) { findLineIndices(of: $1, in: $0) }

    let indicesAfterSelectedLinesChanged = selectedLinesProp
      .withLatestFrom(self.sections) { findLineIndices(of: $0, in: $1) }
      .distinctUntilChanged()

    self.selectedIndices = Observable.merge(indicesAfterLinesChanged, indicesAfterSelectedLinesChanged)
      .startWith([])
      .asDriver(onErrorDriveWith: .never())

    _didSelectIndex
      .withLatestFrom(self.sections, resultSelector: getLineAtIndex)
      .unwrap()
      .bind(onNext: onLineSelected)
      .disposed(by: self.disposeBag)

    _didDeselectIndex
      .withLatestFrom(self.sections, resultSelector: getLineAtIndex)
      .unwrap()
      .bind(onNext: onLineDeselected)
      .disposed(by: self.disposeBag)
  }
}

private func findLineIndices(of lines: [Line], in sections: [LineSelectorSection]) -> [IndexPath] {
  guard lines.any else { return [] }

  var indexMap = [Line:IndexPath]()
  for (sectionIndex, section) in sections.enumerated() {
    for (lineIndex, line) in section.items.enumerated() {
      indexMap[line] = IndexPath(item: lineIndex, section: sectionIndex)
    }
  }

  return lines.compactMap { indexMap[$0] }
}

private func getLineAtIndex(at index: IndexPath, from sections: [LineSelectorSection]) -> Line? {
  guard index.section >= 0
     && index.section < sections.count
    else { return nil }

  let items = sections[index.section].items

  guard index.item >= 0
     && index.item < items.count
    else { return nil }

  return items[index.item]
}
