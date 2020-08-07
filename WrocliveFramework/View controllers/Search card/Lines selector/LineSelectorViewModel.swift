// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol LineSelectorViewType: AnyObject {
  func setPage(page: LineType, animated: Bool)
}

public final class LineSelectorViewModel {

  private var page = LineType.bus
  private let onPageTransition: (LineType) -> ()

  internal let busPageViewModel: LineSelectorPageViewModel
  internal let tramPageViewModel: LineSelectorPageViewModel

  private weak var view: LineSelectorViewType?

  public init(onPageTransition: @escaping (LineType) -> (),
              onLineSelected: @escaping (Line) -> (),
              onLineDeselected: @escaping (Line) -> ()) {
    self.onPageTransition = onPageTransition

    self.tramPageViewModel = LineSelectorPageViewModel(
      onLineSelected: onLineSelected,
      onLineDeselected: onLineDeselected
    )

    self.busPageViewModel = LineSelectorPageViewModel(
      onLineSelected: onLineSelected,
      onLineDeselected: onLineDeselected
    )
  }

  public func setView(view: LineSelectorViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.view?.setPage(page: self.page, animated: false)
  }

  // MARK: - Input

  public func viewDidTransitionToPage(page: LineType) {
    self.onPageTransition(page)
  }

  // MARK: - Set

  public func setPage(page: LineType) {
    self.view?.setPage(page: page, animated: true)
  }

  public func setLines(lines: [Line]) {
    let (busses, trams) = self.splitByLineType(lines: lines)
    self.busPageViewModel.setLines(lines: busses)
    self.tramPageViewModel.setLines(lines: trams)
  }

  public func setSelectedLines(lines: [Line]) {
    let (busses, trams) = self.splitByLineType(lines: lines)
    self.busPageViewModel.setSelectedLines(lines: busses)
    self.tramPageViewModel.setSelectedLines(lines: trams)
  }

  private func splitByLineType(lines: [Line]) -> (busses: [Line], trams: [Line]) {
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
