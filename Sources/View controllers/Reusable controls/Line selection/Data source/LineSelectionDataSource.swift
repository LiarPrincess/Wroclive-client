//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class LineSelectionDataSource: NSObject, UICollectionViewDataSource {

  //MARK: - Properties

  var lines = [Line]() {
    didSet { self.sections = self.sectionCreator.create(from: lines) }
  }

  fileprivate var sections = [LineSelectionSection]()
  fileprivate let sectionCreator: LineSelectionSectionCreatorProtocol = LineSelectionSectionCreator()

  //MARK: - UICollectionViewDataSource

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.sections[section].lines.count
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let view    = collectionView.dequeueReusableSupplementaryView(ofType: LineSelectionSectionHeaderView.self, kind: kind, for: indexPath)
      let section = self.sections[indexPath.section]

      view.setUp(with: LineSelectionSectionHeaderViewModel(for: section.type, section.subtype))
      return view

    default:
      fatalError("Unexpected element kind")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(ofType: LineSelectionCell.self, forIndexPath: indexPath)
    let line = self.sections[indexPath.section].lines[indexPath.row]

    cell.setUp(with: LineSelectionCellViewModel(from: line))
    return cell
  }

  //MARK: - Methods

  func index(of line: Line) -> IndexPath? {
    guard let sectionIndex = self.sections.index(where: { $0.subtype == line.subtype }) else {
      return nil
    }

    let section = self.sections[sectionIndex]
    guard let lineIndex = section.lines.index(where: { $0 == line }) else {
      return nil
    }

    return IndexPath(item: lineIndex, section: sectionIndex)
  }

  func getLine(at indexPath: IndexPath) -> Line? {
    guard indexPath.section < self.sections.count else {
      return nil
    }

    let section = self.sections[indexPath.section]
    guard indexPath.row < section.lines.count else {
      return nil
    }

    return section.lines[indexPath.row]
  }

}
