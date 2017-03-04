//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

class LineSelectionDataSource: NSObject, UICollectionViewDataSource {

  //MARK: - Properties

  var availableLines = [Line]()

  //MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.availableLines.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LineSelectionViewControllerConstants.cellIdentifier, for: indexPath) as! LineSelectionCell

    cell.label.font = UIFont.customPreferredFont(forTextStyle: .body)

    let line = self.availableLines[indexPath.row]
    cell.label.text = line.name
    return cell
  }

}
