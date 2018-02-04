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

  private func indexOf<Cell: ColorSelectionCellViewModel>(cell: Cell, inSection sectionType: ColorSelectionSectionType) -> IndexPath? {
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

  func cellAt(_ indexPath: IndexPath) -> AnyColorSelectionCellViewModel {
    let section = self.sectionAt(indexPath.section)
    guard indexPath.row >= 0 && indexPath.row < section.cellsCount else {
      fatalError("Unexpected row")
    }

    return section.cells[indexPath.row]
  }
}

// MARK: - UICollectionViewDataSource

extension ColorSelectionDataSource: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.sectionAt(section).cellsCount
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let view      = collectionView.dequeueSupplementary(ofType: ColorSelectionSectionHeaderView.self, kind: .header, for: indexPath)
      let viewModel = self.sectionAt(indexPath.section)

      view.setUp(with: viewModel)
      return view

    case UICollectionElementKindSectionFooter:
      return collectionView.dequeueSupplementary(ofType: ColorSelectionSectionFooterView.self, kind: .footer, for: indexPath)

    default:
      fatalError("Unexpected element kind")
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell      = collectionView.dequeueCell(ofType: ColorSelectionCell.self, forIndexPath: indexPath)
    let viewModel = self.sectionAt(indexPath.section).cells[indexPath.row]

    cell.setUp(with: viewModel)
    return cell
  }
}
