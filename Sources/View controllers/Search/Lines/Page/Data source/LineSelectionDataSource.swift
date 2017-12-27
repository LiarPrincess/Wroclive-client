//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class LineSelectionDataSource: NSObject {

  // MARK: - Properties

  var lines: [Line] { return self.sections.flatMap { $0.lines } }

  fileprivate var sections: [LineSelectionSection]

  // MARK: - Init

  init(with lines: [Line]) {
    self.sections = LineSelectionSectionFactory.convert(lines)
  }

  // MARK: - Methods

  func index(of line: Line) -> IndexPath? {
    guard let sectionIndex = self.sections.index(where: { $0.subtype == line.subtype })
      else { return nil }

    guard let itemIndex = self.sections[sectionIndex].lines.index(where: { $0 == line })
      else { return nil }

    return IndexPath(item: itemIndex, section: sectionIndex)
  }

  func line(at indexPath: IndexPath) -> Line? {
    guard indexPath.section < self.sections.count
      else { return nil }

    let section = self.sections[indexPath.section]
    guard indexPath.item < section.lines.count
      else { return nil }

    return section.lines[indexPath.row]
  }
}

// MARK: - UICollectionViewDataSource

extension LineSelectionDataSource: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.sections[section].lines.count
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let view  = collectionView.dequeueReusableSupplementaryView(ofType: LineSelectionHeaderView.self, kind: .header, for: indexPath)
      let section = self.sections[indexPath.section]
      view.viewModel.inputs.section.onNext(section)
      return view

    default:
      fatalError("Unexpected element kind")
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell    = collectionView.dequeueReusableCell(ofType: LineSelectionCell.self, forIndexPath: indexPath)
    let section = self.sections[indexPath.section]
    let line    = section.lines[indexPath.item]
    cell.viewModel.inputs.line.onNext(line)

    return cell
  }
}
