//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private typealias Layout = BookmarksCellConstants.Layout

protocol BookmarksCellViewModelInput {
  var bookmark: AnyObserver<Bookmark> { get }
}

protocol BookmarksCellViewModelOutput {
  var name:  Driver<String> { get }
  var lines: Driver<String> { get }
}

class BookmarksCellViewModel: BookmarksCellViewModelInput, BookmarksCellViewModelOutput {

  // MARK: - Properties

  private let _bookmark = PublishSubject<Bookmark>()

  // MARK: - Input

  lazy var bookmark: AnyObserver<Bookmark> = self._bookmark.asObserver()

  // MARK: - Output

  lazy var name: Driver<String> = self._bookmark
    .map { createName($0) }
    .asDriver(onErrorDriveWith: .never())

  lazy var lines: Driver<String> = self._bookmark
    .map { createLinesLabel($0) }
    .asDriver(onErrorDriveWith: .never())

  // MARK: - Input/Output

  var inputs:  BookmarksCellViewModelInput  { return self }
  var outputs: BookmarksCellViewModelOutput { return self }
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
