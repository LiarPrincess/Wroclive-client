//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ConfigurationDataSource: NSObject {

  // MARK: - Properties

  fileprivate lazy var sections: [ConfigurationSection] = {
    let personalizationSection = ConfigurationSection(for: .personalization)
    let aboutSection           = ConfigurationSection(for: .about)
    return [personalizationSection, aboutSection]
  }()

  // MARK: - Methods

  func sectionAt(_ section: Int) -> ConfigurationSection {
    guard section >= 0 && section < self.sections.count else {
      fatalError("Unexpected section")
    }

    return self.sections[section]
  }

  func cellAt(_ indexPath: IndexPath) -> ConfigurationCell {
    let section = self.sectionAt(indexPath.section)
    guard indexPath.row >= 0 && indexPath.row < section.cellsCount else {
      fatalError("Unexpected row")
    }

    return section.cells[indexPath.row]
  }
}

extension ConfigurationDataSource: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sectionAt(section).cellsCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let textAttributes = Managers.theme.textAttributes(for: .body)

    let cell = tableView.dequeueReusableCell(ofType: UITableViewCell.self, forIndexPath: indexPath)
    let cellViewModel = self.cellAt(indexPath)

    cell.textLabel?.attributedText = NSAttributedString(string: cellViewModel.text, attributes: textAttributes)
    cell.backgroundColor = Managers.theme.colorScheme.background
    cell.accessoryType = cellViewModel.accessoryType
//    cell.isEnabled     = cellViewModel.isEnabled
    return cell
  }
}
