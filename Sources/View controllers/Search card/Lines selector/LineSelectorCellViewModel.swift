//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

private typealias TextStyles = LineSelectorCellConstants.TextStyles

class LineSelectorCellViewModel {
  private      var line: Line
  private(set) var text: NSAttributedString

  init(_ line: Line) {
    self.line = line
    self.text = createText(line.name, isSelected: false)
  }

  func updateText(isCellSelected: Bool) {
    self.text = createText(line.name, isSelected: isCellSelected)
  }
}

private func createText(_ value: String, isSelected: Bool) -> NSAttributedString {
  let attributes = createTextAttributes(isSelected: isSelected)
  return NSAttributedString(string: value.uppercased(), attributes: attributes)
}

private func createTextAttributes(isSelected: Bool) -> TextAttributes {
  switch isSelected {
  case true:  return TextStyles.selected
  case false: return TextStyles.notSelected
  }
}
