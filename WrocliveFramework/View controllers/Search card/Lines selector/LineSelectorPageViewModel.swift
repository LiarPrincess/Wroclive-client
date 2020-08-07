// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

internal protocol LineSelectorPageType: AnyObject {
  func setSections(sections: [LineSelectorSection])
  func setSelectedIndices(indices: [IndexPath], animated: Bool)
}

internal final class LineSelectorPageViewModel {

  private var sections = [LineSelectorSection]()
  private var selectedLines = [Line]()

  private let onLineSelected: (Line) -> ()
  private let onLineDeselected: (Line) -> ()

  private weak var view: LineSelectorPageType?

  // MARK: - Init

  internal init(onLineSelected: @escaping (Line) -> (),
                onLineDeselected: @escaping (Line) -> ()) {
    self.onLineSelected = onLineSelected
    self.onLineDeselected = onLineDeselected
  }

  internal func setView(view: LineSelectorPageType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view

    let selectedIndices = self.getIndices(of: self.selectedLines)
    self.view?.setSections(sections: self.sections)
    self.view?.setSelectedIndices(indices: selectedIndices, animated: true)
  }

  // MARK: - Input

  internal func setLines(lines: [Line]) {
    self.sections = LineSelectorSection.create(from: lines)
    self.view?.setSections(sections: sections)

    // Indices may have changed and also because of how 'UICollectionView' works
    // we need re-post 'selectedIndices' every time 'lines' change.
    let selectedIndices = self.getIndices(of: self.selectedLines)
    self.view?.setSelectedIndices(indices: selectedIndices, animated: true)
  }

  internal func setSelectedLines(lines: [Line]) {
    self.selectedLines = lines

    let selectedIndices = self.getIndices(of: self.selectedLines)
    self.view?.setSelectedIndices(indices: selectedIndices, animated: true)
  }

  internal func viewDidSelectIndex(index: IndexPath) {
    guard let line = getLine(at: index) else {
      return
    }

    self.onLineSelected(line)
  }

  internal func viewDidDeselectIndex(index: IndexPath) {
    guard let line = getLine(at: index) else {
      return
    }

    self.onLineDeselected(line)
  }

  // MARK: - Helpers

  private func getIndices(of lines: [Line]) -> [IndexPath] {
    guard lines.any else {
      return []
    }

    var indexMap = [Line:IndexPath]()
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
