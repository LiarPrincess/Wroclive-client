// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

class LineSelectorPageViewModelTests: XCTestCase, LineSelectorPageType {

  internal typealias Page = SearchCardState.Page
  internal typealias TestData = LineSelectorTestData

  private let lines = TestData.busLines
  private let sections = TestData.busSections

  /// Select last line in each section
  private lazy var selected: (lines: [Line], indices: [IndexPath]) = {
    var lines = [Line]()
    var indices = [IndexPath]()

    for (sectionIndex, section) in self.sections.enumerated() {
      guard let line = section.lines.last else { continue }
      lines.append(line)

      let lineIndex = section.lines.count - 1
      indices.append(IndexPath(item: lineIndex, section: sectionIndex))
    }

    return (lines, indices)
  }()

  private var refreshCount = 0

  override func setUp() {
    super.setUp()
    self.refreshCount = 0
  }

  // MARK: - View model

  func createViewModel() -> LineSelectorPageViewModel {
    let result = LineSelectorPageViewModel()
    result.setView(view: self)
    self.refreshCount = 0
    return result
  }

  func refresh() {
    self.refreshCount += 1
  }

  // MARK: - Lines, selected lines

  func test_lines_selectedLines_initialState() {
    let viewModel = self.createViewModel()
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertEqual(viewModel.sections, [])
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])
  }

  /// This test simulates following scenario:
  /// - we do not have line response (yet)
  /// - we have selected lines from file
  /// (refresh)
  /// - we get lines response
  /// (refresh)
  func test_lineRequestInProgress_selectedLinesAlreadyThere() {
    let viewModel = self.createViewModel()
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertEqual(viewModel.sections, [])
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    viewModel.setSelectedLines(lines: self.selected.lines)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, [])
    XCTAssertEqual(viewModel.selectedLines, self.selected.lines)
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    viewModel.setSections(sections: self.sections)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, self.selected.lines)
    XCTAssertEqual(viewModel.selectedLineIndices, self.selected.indices)
  }

  /// This test simulates following scenario:
  /// - we have lines response already cached
  /// - we have selected lines from file
  func test_lineRequestAlreadyThere_asDoSelectedLines() {
    let viewModel = self.createViewModel()
    XCTAssertEqual(self.refreshCount, 0)
    XCTAssertEqual(viewModel.sections, [])
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    viewModel.setSections(sections: self.sections)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    viewModel.setSelectedLines(lines: self.selected.lines)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, self.selected.lines)
    XCTAssertEqual(viewModel.selectedLineIndices, self.selected.indices)
  }

  func test_settingLines_toCurrentValue_doesNothing() {
    let viewModel = self.createViewModel()
    viewModel.setSections(sections: self.sections)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    viewModel.setSections(sections: self.sections)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])
  }

  func test_settingSelectedLines_toCurrentValue_doesNothing() {
    let viewModel = self.createViewModel()
    viewModel.setSections(sections: self.sections)
    viewModel.setSelectedLines(lines: self.selected.lines)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, self.selected.lines)
    XCTAssertEqual(viewModel.selectedLineIndices, self.selected.indices)

    viewModel.setSelectedLines(lines: self.selected.lines)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, self.selected.lines)
    XCTAssertEqual(viewModel.selectedLineIndices, self.selected.indices)
  }

  // MARK: - Select/deselect line

  func test_lineSelect() {
    let viewModel = self.createViewModel()
    viewModel.setSections(sections: self.sections)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    for index in self.selected.indices {
      viewModel.viewDidSelectIndex(index: index)
    }

    let initialRefresh = 1
    XCTAssertEqual(self.refreshCount, self.selected.indices.count + initialRefresh)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, self.selected.lines)
    XCTAssertEqual(viewModel.selectedLineIndices, self.selected.indices)
  }

  func test_lineSelect_indexOutOfRange() {
    let viewModel = self.createViewModel()
    viewModel.setSections(sections: self.sections)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    let invalidSection = IndexPath(item: 0, section: Int.max)
    viewModel.viewDidSelectIndex(index: invalidSection)

    // No changes
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    let invalidItem = IndexPath(item: Int.max, section: 0)
    viewModel.viewDidSelectIndex(index: invalidItem)

    // No changes
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])
  }

  func test_lineDeselect() {
    let viewModel = self.createViewModel()
    viewModel.setSections(sections: self.sections)
    viewModel.setSelectedLines(lines: self.selected.lines)
    XCTAssertEqual(self.refreshCount, 2)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, self.selected.lines)
    XCTAssertEqual(viewModel.selectedLineIndices, self.selected.indices)

    for index in self.selected.indices {
      viewModel.viewDidDeselectIndex(index: index)
    }

    let initialRefresh = 2
    XCTAssertEqual(self.refreshCount, self.selected.indices.count + initialRefresh)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])
  }

  func test_lineDeselect_indexOutOfRange() {
    let viewModel = self.createViewModel()
    viewModel.setSections(sections: self.sections)
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    let invalidSection = IndexPath(item: 0, section: Int.max)
    viewModel.viewDidDeselectIndex(index: invalidSection)

    // No changes
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])

    let invalidItem = IndexPath(item: Int.max, section: 0)
    viewModel.viewDidDeselectIndex(index: invalidItem)

    // No changes
    XCTAssertEqual(self.refreshCount, 1)
    XCTAssertEqual(viewModel.sections, self.sections)
    XCTAssertEqual(viewModel.selectedLines, [])
    XCTAssertEqual(viewModel.selectedLineIndices, [])
  }
}
