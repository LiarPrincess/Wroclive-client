//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ColorSelectionDataSource: NSObject {

  // MARK: - Properties

//  fileprivate lazy var tintSectionViewModel: ColorSelectionSectionViewModel<TintColor> = {
//    let section = ColorSelectionSection.tint
//    return ColorSelectionSectionViewModel(withName: section.name, colors: [])
//  }()
//
//  fileprivate lazy var tramSectionViewModel: ColorSelectionSectionViewModel<VehicleColor> = {
//    let section = ColorSelectionSection.tram
//    return ColorSelectionSectionViewModel(withName: section.name, colors: [])
//  }()
//
//  fileprivate lazy var busSectionViewModel: ColorSelectionSectionViewModel<VehicleColor> = {
//    let section = ColorSelectionSection.bus
//    return ColorSelectionSectionViewModel(withName: section.name, colors: [])
//  }()

}

// MARK: - UICollectionViewDataSource

extension ColorSelectionDataSource: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return ColorSelectionSection.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let section = ColorSelectionSection(rawValue: section) else { fatalError("Unexpected Section") }
    return section.cellViewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      guard let viewModel = ColorSelectionSection(rawValue: indexPath.section) else { fatalError("Unexpected Section") }

      let view = collectionView.dequeueReusableSupplementaryView(ofType: ColorSelectionSectionHeaderView.self, kind: kind, for: indexPath)
      view.setUp(with: viewModel)
      return view

    default:
      fatalError("Unexpected element kind")
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let section = ColorSelectionSection(rawValue: indexPath.section) else { fatalError("Unexpected Section") }
    let viewModel = section.cellViewModels[indexPath.row]

    let cell = collectionView.dequeueReusableCell(ofType: ColorSelectionCell.self, forIndexPath: indexPath)
    cell.setUp(with: viewModel)
    return cell
  }
}
