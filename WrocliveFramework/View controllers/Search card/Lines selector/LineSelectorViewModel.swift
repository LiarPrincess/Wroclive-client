// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol LineSelectorViewType: AnyObject {
  func refresh()
}

public final class LineSelectorViewModel {

  internal private(set) var page: LineType

  internal let busPageViewModel: LineSelectorPageViewModel
  internal let tramPageViewModel: LineSelectorPageViewModel

  private let onPageTransition: (LineType) -> Void
  private weak var view: LineSelectorViewType?

  // MARK: - Init

  public init(initialPage page: LineType,
              onPageTransition: @escaping (LineType) -> Void) {
    self.page = page
    self.onPageTransition = onPageTransition
    self.tramPageViewModel = LineSelectorPageViewModel()
    self.busPageViewModel = LineSelectorPageViewModel()
  }

  // MARK: - View

  public func setView(view: LineSelectorViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.refreshView()
  }

  private func refreshView() {
    self.view?.refresh()
  }

  // MARK: - Selected lines

  public struct SelectedLines {
    public let busses: [Line]
    public let trams: [Line]

    public var isAnyLineSelected: Bool {
      return self.busses.any || self.trams.any
    }

    public func merge() -> [Line] {
      return self.busses + self.trams
    }
  }

  public var selectedLines: SelectedLines {
    return SelectedLines(
      busses: self.busPageViewModel.selectedLines,
      trams: self.tramPageViewModel.selectedLines
    )
  }

  // MARK: - View input

  public func viewDidTransitionToPage(page: LineType) {
    self.onPageTransition(page)
  }

  // MARK: - Methods

  public func setPage(page: LineType) {
    if page == self.page {
      return
    }

    self.page = page
    self.refreshView()
  }

  public func setLines(lines: [Line]) {
    let (busses, trams) = self.groupByLineType(lines: lines)
    self.busPageViewModel.setLines(lines: busses)
    self.tramPageViewModel.setLines(lines: trams)
  }

  public func setSelectedLines(lines: [Line]) {
    let (busses, trams) = self.groupByLineType(lines: lines)
    self.busPageViewModel.setSelectedLines(lines: busses)
    self.tramPageViewModel.setSelectedLines(lines: trams)
  }

  private func groupByLineType(lines: [Line]) -> (busses: [Line], trams: [Line]) {
    var trams = [Line]()
    var busses = [Line]()

    for line in lines {
      switch line.type {
      case .tram: trams.append(line)
      case .bus: busses.append(line)
      }
    }

    return (busses, trams)
  }
}
