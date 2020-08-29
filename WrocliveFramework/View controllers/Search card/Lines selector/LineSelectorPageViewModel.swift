// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

internal protocol LineSelectorPageType: AnyObject {
  func refresh()
}

internal final class LineSelectorPageViewModel {

  internal private(set) var sections: [LineSelectorSection]

  internal private(set) var selectedLines: [Line]
  internal private(set) var selectedLineIndices: [IndexPath]

  private weak var view: LineSelectorPageType?

  // MARK: - Init

  internal init() {
    self.sections = []
    self.selectedLines = []
    self.selectedLineIndices = []
  }

  // MARK: - View

  internal func setView(view: LineSelectorPageType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.refreshView()
  }

  private func refreshView() {
    self.view?.refresh()
  }

  // MARK: - View input

  internal func viewDidSelectIndex(index: IndexPath) {
    guard let line = getLine(at: index) else {
      return
    }

    // Avoid duplicates
    if self.selectedLines.contains(line) {
      return
    }

    self.selectedLines.append(line)
    self.updateSelectedLineIndices()
    self.refreshView()
  }

  internal func viewDidDeselectIndex(index: IndexPath) {
    guard let line = getLine(at: index) else {
      return
    }

    // Use 'filter' instead of index-based-removal, to handle duplicates.
    // (I don't know why we would have duplicate, but it is better to be safe than sorry)
    self.selectedLines = self.selectedLines.filter { $0 != line }
    self.updateSelectedLineIndices()
    self.refreshView()
  }

  // MARK: - Methods

  internal func setSections(sections: [LineSelectorSection]) {
    if sections == self.sections {
      return
    }

    // We need to also re-calcualte selected indices as they may have changed.
    self.sections = sections
    self.updateSelectedLineIndices()
    self.refreshView()
  }

  internal func setSelectedLines(lines: [Line]) {
    if lines == self.selectedLines {
      return
    }

    self.selectedLines = lines
    self.updateSelectedLineIndices()
    self.refreshView()
  }

  private func updateSelectedLineIndices() {
    self.selectedLineIndices = self.getIndices(of: self.selectedLines)
  }

  // MARK: - Helpers

  private func getIndices(of lines: [Line]) -> [IndexPath] {
    guard lines.any else {
      return []
    }

    var indexMap = [Line: IndexPath]()
    for (sectionIndex, section) in self.sections.enumerated() {
      for (lineIndex, line) in section.lines.enumerated() {
        indexMap[line] = IndexPath(item: lineIndex, section: sectionIndex)
      }
    }

    return lines.compactMap { indexMap[$0] }
  }

  private func getLine(at index: IndexPath) -> Line? {
    guard self.sections.indices.contains(index.section) else {
      return nil
    }

    let items = self.sections[index.section].lines

    guard items.indices.contains(index.item) else {
      return nil
    }

    return items[index.item]
  }
}
