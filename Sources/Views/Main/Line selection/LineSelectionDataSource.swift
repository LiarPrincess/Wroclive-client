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
    let identifier = "LineSelectionCell"
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? LineSelectionCell else {
      fatalError("The dequeued cell is not an instance of LineSelectionCell")
    }

    let line = self.lines[indexPath.row]
    cell.setUp(with: LineSelectionCellViewModel(from: line))
    return cell
  }

}
