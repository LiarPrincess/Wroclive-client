//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ColorSelectionDataSource: NSObject {

  // MARK: - Properties

  fileprivate lazy var sections: [ColorSelectionSection] = {
    let tintSection = ColorSelectionSection(for: .tint)
    let tramSection = ColorSelectionSection(for: .tram)
    let busSection  = ColorSelectionSection(for: .bus)
    return [tintSection, tramSection, busSection]
  }()

  // MARK: - IndexOf(color:)

  func indexOf(tintColor: TintColor) -> IndexPath? {
    return self.indexOf(cell: tintColor, inSection: .tint)
  }

  func indexOf(tramColor: VehicleColor) -> IndexPath? {
    return self.indexOf(cell: tramColor, inSection: .tram)
  }

  func indexOf(busColor: VehicleColor) -> IndexPath? {
    return self.indexOf(cell: busColor, inSection: .bus)
  }

  private func indexOf<TCell: ColorSelectionCellViewModel>(cell: TCell, inSection sectionType: ColorSelectionSectionType) -> IndexPath? {
    if let section = self.sections.index(where: { $0.type == sectionType }),
       let row     = self.sections[section].cells.index(where: { $0.color == cell.color }) {
      return IndexPath(row: row, section: section)
    }
    return nil
  }

  // MARK: - SectionAt, CellAt

  func sectionAt(_ section: Int) -> ColorSelectionSection {
    guard section >= 0 && section < self.sections.count else {
      fatalError("Unexpected section")
    }

    return self.sections[section]
  }

  func cellAt(_ indexPath: IndexPath) -> ColorSelectionCellViewModel {
    let section = self.sectionAt(indexPath.section)
    guard indexPath.row >= 0 && indexPath.row < section.cellsCount else {
      fatalError("Unexpected row")
    }

    return section.cells[indexPath.row]
  }
}

extension ColorSelectionDataSource: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return self.sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sectionAt(section).cellsCount
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.sectionAt(section).name
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell  = tableView.dequeueReusableCell(ofType: UITableViewCell.self, forIndexPath: indexPath)
    let viewModel = self.cellAt(indexPath)

    cell.textLabel?.text      = "Color name"
    cell.imageView?.tintColor = viewModel.color
    cell.imageView?.image     = StyleKit.drawRoundedRectangleTemplateImage(size: CGSize(width: 40.0, height: 40.0))
    cell.selectionStyle = .none
    return cell
  }
}
