//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class LineSelectionDataSource: NSObject {

  //MARK: - Properties

  fileprivate var viewModels: [LineSelectionSectionViewModel]

  //MARK: - Init

  init(with lines: [Line]) {
    self.viewModels = LineSelectionSectionViewModelFactory.convert(lines)
  }

  //MARK: - Methods

  func sectionName(at section: Int) -> String? {
    return section < self.viewModels.count ? self.viewModels[section].sectionName : nil
  }

  func index(of line: Line) -> IndexPath? {
    guard let sectionIndex = self.viewModels.index(where: { $0.subtype == line.subtype }) else {
      return nil
    }

    guard let itemIndex = self.viewModels[sectionIndex].lines.index(where: { $0 == line }) else {
      return nil
    }

    return IndexPath(item: itemIndex, section: sectionIndex)
  }

  func line(at indexPath: IndexPath) -> Line? {
    guard indexPath.section < self.viewModels.count else {
      return nil
    }

    let section = self.viewModels[indexPath.section]
    guard indexPath.row < section.lines.count else {
      return nil
    }

    return section.lines[indexPath.row]
  }

}

//MARK: - UICollectionViewDataSource

extension LineSelectionDataSource: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.viewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.viewModels[section].lines.count
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let view      = collectionView.dequeueReusableSupplementaryView(ofType: LineSelectionSectionHeaderView.self, kind: kind, for: indexPath)
      let viewModel = self.viewModels[indexPath.section]

      view.setUp(with: viewModel)
      return view

    default:
      fatalError("Unexpected element kind")
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(ofType: LineSelectionCell.self, forIndexPath: indexPath)
    let viewModel = self.viewModels[indexPath.section].lineViewModels[indexPath.row]

    cell.setUp(with: viewModel)
    return cell
  }

}
