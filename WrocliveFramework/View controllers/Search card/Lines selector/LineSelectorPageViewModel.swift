// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

internal protocol LineSelectorPageType: AnyObject {
  func refresh()
}

internal final class LineSelectorPageViewModel {

  internal var sections: [LineSelectorSection] {
     didSet { self.needsViewRefresh = true }
   }

  private var selectedLines: [Line]
  internal var selectedLineIndices: [IndexPath] {
     didSet { self.needsViewRefresh = true }
   }

  private let onLineSelected: (Line) -> ()
  private let onLineDeselected: (Line) -> ()

  private weak var view: LineSelectorPageType?

  // MARK: - Init

  internal init(onLineSelected: @escaping (Line) -> (),
                onLineDeselected: @escaping (Line) -> ()) {
    self.sections = []
    self.selectedLines = []
    self.selectedLineIndices = []
    self.onLineSelected = onLineSelected
    self.onLineDeselected = onLineDeselected
  }

  // MARK: - View

  private var needsViewRefresh = false

  internal func setView(view: LineSelectorPageType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.refreshView()
  }

  private func refreshView() {
    self.view?.refresh()
    self.needsViewRefresh = false
  }

  // MARK: - Input

  internal func setLines(lines: [Line]) {
    // We need to also re-post selected indices as they may have changed
    // (and also because of how 'UICollectionView' works).
    self.sections = Self.createSections(from: lines)
    self.selectedLineIndices = self.getIndices(of: self.selectedLines)
    self.refreshView()
  }

  internal static func createSections(from lines: [Line]) -> [LineSelectorSection] {
     let linesBySubtype = lines.group { $0.subtype }

     var result = [LineSelectorSection]()
     for (subtype, var lines) in linesBySubtype {
       lines.sortByLocalizedName()
       result.append(LineSelectorSection(for: subtype, lines: lines))
     }

     result.sort { lhs, rhs in
       let lhsOrder = Self.getSectionOrder(subtype: lhs.lineSubtype)
       let rhsOrder = Self.getSectionOrder(subtype: rhs.lineSubtype)
       return lhsOrder < rhsOrder
     }

     return result
   }

  private static func getSectionOrder(subtype: LineSubtype) -> Int {
    switch subtype {
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

  internal func setSelectedLines(lines: [Line]) {
    self.selectedLines = lines
    self.selectedLineIndices = self.getIndices(of: self.selectedLines)
    self.refreshView()
  }

  // MARK: - View input

  internal func viewDidSelectIndex(index: IndexPath) {
    if let line = getLine(at: index) {
      self.onLineSelected(line)
    }
  }

  internal func viewDidDeselectIndex(index: IndexPath) {
    if let line = getLine(at: index) {
      self.onLineDeselected(line)
    }
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
