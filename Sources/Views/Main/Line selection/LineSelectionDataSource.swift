//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit


class LineSelectionDataSource: NSObject, UICollectionViewDataSource {

  //MARK: - Properties

  var lines = [Line]()

  //MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.lines.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(ofType: LineSelectionCell.self, forIndexPath: indexPath)
    let line = self.lines[indexPath.row]
    
    cell.setUp(with: LineSelectionCellViewModel(from: line))
    return cell
  }

}
