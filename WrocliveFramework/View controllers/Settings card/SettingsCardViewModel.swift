// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol SettingsCardViewModelDelegate: AnyObject {
  func rateApp()
  func showAboutPage()
  func showShareActivity()
}

public final class SettingsCardViewModel {

  public let sections = [
    SettingsSection(
      kind: .general,
      cells: [.share, .rate, .about]
    )
  ]

  private weak var delegate: SettingsCardViewModelDelegate?

  // MARK: - Init

  public init(delegate: SettingsCardViewModelDelegate) {
    self.delegate = delegate
  }

  // MARK: - View inputs

  public func viewDidSelectRow(at index: IndexPath) {
    guard let (_, cell) = self.getCell(at: index) else {
      return
    }

    switch cell {
    case .share: self.delegate?.showShareActivity()
    case .rate: self.delegate?.rateApp()
    case .about: self.delegate?.showAboutPage()
    }
  }

  // MARK: - Get

  public typealias SectionAndCell = (SettingsSection, SettingsSection.CellKind)

  public func getSection(at index: Int) -> SettingsSection? {
    guard self.sections.indices.contains(index) else {
      return nil
    }

    return self.sections[index]
  }

  public func getCell(at index: IndexPath) -> SectionAndCell? {
    let sectionIndex = index.section
    let cellIndex = index.row

    guard let section = self.getSection(at: sectionIndex) else {
      return nil
    }

    guard section.cells.indices.contains(cellIndex) else {
      return nil
    }

    let cell = section.cells[cellIndex]
    return (section, cell)
  }
}
