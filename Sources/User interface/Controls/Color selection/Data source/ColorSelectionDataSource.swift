//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ColorSelectionDataSource: NSObject {

  // MARK: - Properties

  fileprivate lazy var sections: [ColorSelectionSection] = {
    let tintSection = ColorSelectionSection(for: .tint)
    let tramSection = ColorSelectionSection(for: .tram)
    let busSection  = ColorSelectionSection(for: .bus)
    return [tintSection, tramSection, busSection]
  }()

  // MARK: - Methods

  func sectionAt(_ section: Int) -> ColorSelectionSection {
    guard section >= 0 && section < self.sections.count else {
      fatalError("Unexpected section")
    }

    return self.sections[section]
  }

  func colorAt(_ indexPath: IndexPath) -> AnyColorSelectionSectionColor {
    let section = self.sectionAt(indexPath.section)
    guard indexPath.row >= 0 && indexPath.row < section.colorsCount else {
      fatalError("Unexpected row")
    }

    return section.colors[indexPath.row]
  }
}

extension ColorSelectionDataSource: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return self.sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sectionAt(section).colorsCount
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.sectionAt(section).name
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell  = tableView.dequeueReusableCell(ofType: UITableViewCell.self, forIndexPath: indexPath)
    let color = self.colorAt(indexPath)

    cell.textLabel?.text      = "Color name"
    cell.imageView?.tintColor = color.color
    cell.imageView?.image     = StyleKit.drawRoundedRectangleTemplateImage(size: CGSize(width: 40.0, height: 40.0))
    return cell
  }
}
