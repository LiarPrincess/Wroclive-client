// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

internal protocol LineTypeSelectorViewModelDelegate: AnyObject {
  func lineTypeSelectorViewModel(didSelectPage page: LineType)
}

internal protocol LineTypeSelectorViewType: AnyObject {
  func setPage(index: Int)
}

internal final class LineTypeSelectorViewModel {

  private var selectedIndex = 0
  private let pages = [LineType.tram, LineType.bus]
  internal private(set) lazy var pageNames = self.pages.map(Self.toPageName)

  private weak var view: LineTypeSelectorViewType?
  private weak var delegate: LineTypeSelectorViewModelDelegate?

  internal init(delegate: LineTypeSelectorViewModelDelegate) {
    self.delegate = delegate
  }

  public func setView(view: LineTypeSelectorViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view

    // Set initial selected index
    self.view?.setPage(index: self.selectedIndex)
  }

  // MARK: - Input

  internal func setPage(page: LineType) {
    guard let index = self.pages.firstIndex(of: page) else {
      fatalError("Unknown line type: \(page)")
    }

    self.selectedIndex = index
    self.view?.setPage(index: index)
  }

  internal func viewDidSelect(index: Int) {
    let page = self.pages[index]
    self.delegate?.lineTypeSelectorViewModel(didSelectPage: page)
  }

  // MARK: - Helpers

  private static func toPageName(_ lineType: LineType) -> String {
    typealias L = Localizable.Search

    switch lineType {
    case .tram: return L.Pages.tram
    case .bus:  return L.Pages.bus
    }
  }
}
