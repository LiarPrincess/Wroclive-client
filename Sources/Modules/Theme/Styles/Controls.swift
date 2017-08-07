//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

// MARK: - Color

enum Color {
  case background
  case backgroundAccent
  case text
  case tint
  case bus
  case tram
}

// MARK: - Label

extension UILabel {
  func setStyle(_ style: LabelStyle, color: Color) {
    Theme.current.apply(toLabel: self, style: style, color: color)
  }
}

// MARK: - Buttons

extension UIButton {
  func setStyle(_ style: ButtonStyle, color: Color) {
    Theme.current.apply(toButton: self, style: style, color: color)
  }
}

extension UISegmentedControl {
  func setStyle() {
    Theme.current.apply(toSegmentedControl: self)
  }
}

extension UIToolbar {
  func setStyle() {
    Theme.current.apply(toToolbar: self)
  }
}

// MARK: - Table

extension UITableView {
  func setStyle(separatorStyle: TableSeparatorStyle) {
    Theme.current.apply(toTable: self, separatorStyle: separatorStyle)
  }
}

// MARK: - Views

extension UIView {
  func setStyle(_ style: ViewStyle) {
    Theme.current.apply(toView: self, style: style)
  }
}
