//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

fileprivate typealias Constants = LineSelectionViewControllerConstants

//MARK: - LineSelectionDataSource

class LineSelectionDataSource: NSObject {

  //MARK: - Properties

  var lines = [Line]() {
    didSet { self.sections = self.sectionCreator.create(from: lines) }
  }

  fileprivate var sections = [LineSelectionSection]()
  fileprivate let sectionCreator: LineSelectionSectionCreatorProtocol = LineSelectionSectionCreator()
}

//MARK: - UICollectionViewDataSource

extension LineSelectionDataSource: UICollectionViewDataSource {

  //MARK: - Data

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.sections[section].lines.count
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let view    = collectionView.dequeueReusableSupplementaryView(ofType: LineSelectionCellHeader.self, kind: kind, for: indexPath)
      let section = self.sections[indexPath.section]

      view.setUp(with: LineSelectionCellHeaderViewModel(from: section))
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

}
