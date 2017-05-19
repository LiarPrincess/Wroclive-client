//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

class LineSelectionDataSource: NSObject, UICollectionViewDataSource {

  //MARK: - Properties

  fileprivate var lines = [Line]()

  var availableLines = [Line]() {
    didSet {
      self.lines = self.filterAndOrder(self.availableLines)
    }
  }

  var vehicleTypeFilter: VehicleType? {
    didSet {
      self.lines = self.filterAndOrder(self.availableLines)
    }
  }

  //MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.lines.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = LineSelectionViewControllerConstants.CellIdentifiers.line
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? LineSelectionCell else {
      fatalError("The dequeued cell is not an instance of LineSelectionCell")
    }

    cell.label.font = UIFont.customPreferredFont(forTextStyle: .body)

    let line = self.lines[indexPath.row]
    cell.label.text = line.name
    return cell
  }

}

//MARK: - Filtering and ordering

extension LineSelectionDataSource {

  fileprivate func filterAndOrder(_ lines: [Line]) -> [Line] {
    return self.sort(self.applyFilter(lines))
  }

  //MARK: - Filter

  private typealias LineFilter = (Line) -> Bool

  fileprivate func applyFilter(_ lines: [Line]) -> [Line] {
    var filter: LineFilter = { _ in return true }

    if let vehicleTypeFilter = self.vehicleTypeFilter {
      filter += { $0.type == vehicleTypeFilter }
    }

    return lines.filter(filter)
  }

  //MARK: - Order

  private func sort(_ lines: [Line]) -> [Line] {
    let nameSort = { (lhs: Line, rhs: Line) in return lhs.name > rhs.name }

    let tramLines = lines.filter { $0.type == .tram }.sorted(by: nameSort)
    let busLines = lines.filter { $0.type == .bus }.sorted(by: nameSort)
    return tramLines + busLines
  }

}
