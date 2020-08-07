// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private typealias TextStyles = LineSelectorCellConstants.TextStyles

public final class LineSelectorCellViewModel {
  private let line: Line
  internal private(set) var text: NSAttributedString

  public init(_ line: Line) {
    self.line = line
    self.text = createText(line.name, isSelected: false)
  }

  public func updateText(isCellSelected: Bool) {
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
