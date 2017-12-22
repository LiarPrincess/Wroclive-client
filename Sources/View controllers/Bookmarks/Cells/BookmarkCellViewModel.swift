//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private typealias Layout = BookmarkCellConstants.Layout

protocol BookmarkCellViewModelInput {
  var bookmark: AnyObserver<Bookmark> { get }
}

protocol BookmarkCellViewModelOutput {
  var name:  Driver<String> { get }
  var lines: Driver<String> { get }
}

class BookmarkCellViewModel: BookmarkCellViewModelInput, BookmarkCellViewModelOutput {

  private let _bookmark = PublishSubject<Bookmark>()

  // input
  var bookmark: AnyObserver<Bookmark> { return self._bookmark.asObserver() }

  // output
  let name:  Driver<String>
  let lines: Driver<String>

  init() {
    let bookmarkStream = self._bookmark.asObservable().share()

    self.name = bookmarkStream
      .map { createName($0) }
      .asDriver(onErrorDriveWith: .never())

    self.lines = bookmarkStream
      .map { createLinesLabel($0) }
      .asDriver(onErrorDriveWith: .never())
  }

  // MARK: - Input/Output

  var inputs:  BookmarkCellViewModelInput  { return self }
  var outputs: BookmarkCellViewModelOutput { return self }
}

private func createName(_ bookmark: Bookmark) -> String {
  return bookmark.name
}

private func createLinesLabel(_ bookmark: Bookmark) -> String {
  let tramLines = bookmark.lines.filter(.tram)
  let busLines  = bookmark.lines.filter(.bus)

  let hasTramLines = !tramLines.isEmpty
  let hasBusLines  = !busLines.isEmpty
  let hasTramAndBusLines = hasTramLines && hasBusLines

  var result = ""
  if hasTramLines       { result += concatNames(tramLines) }
  if hasTramAndBusLines { result += "\n" }
  if hasBusLines        { result += concatNames(busLines) }

  return result
}

private func concatNames(_ lines: [Line]) -> String {
  return lines
    .sorted(by: .name)
    .map { (line: Line) in line.name }
    .joined(separator: Layout.LinesLabel.horizontalSpacing)
}
