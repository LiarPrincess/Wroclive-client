//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

fileprivate typealias Constants = LineSelectionViewControllerConstants

//MARK: - Section

fileprivate struct Section {
  let subtype: LineSubtype
  let lines:   [Line]
}

//MARK: - LineSelectionDataSource

class LineSelectionDataSource: NSObject {

  //MARK: - Properties

  var lines = [Line]() {
    didSet { self.sections = self.createSections(from: lines) }
  }

  fileprivate var sections = [Section]()

  //MARK: - Methods

  private func createSections(from lines: [Line]) -> [Section] {
    var linesBySubtype = [LineSubtype:[Line]]()

    for line in lines {
      if let value = linesBySubtype[line.subtype] {
        linesBySubtype[line.subtype] = value + [line]
      }
      else {
        linesBySubtype[line.subtype] = [line]
      }
    }

    return linesBySubtype.sorted(by: { (lhs, rhs) in
      return Constants.sectionOrder(for: lhs.key) < Constants.sectionOrder(for: rhs.key)
    })
    .map {
      return Section(subtype: $0, lines: $1)
    }
  }

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

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(ofType: LineSelectionCell.self, forIndexPath: indexPath)
    let line = self.sections[indexPath.section].lines[indexPath.row]

    cell.setUp(with: LineSelectionCellViewModel(from: line))
    return cell
  }
}
