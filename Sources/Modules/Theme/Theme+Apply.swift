//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension Theme {

  // MARK: - Label

  func apply(toLabel label: UILabel, style: LabelStyle, color: Color) {
    label.textColor = self.getColorValue(color)
    switch style {
    case .headline:    label.font = self.font.headline
    case .subheadline: label.font = self.font.subheadline
    case .body:        label.font = self.font.body
    }
  }

  // MARK: - Buttons

  func apply(toButton button: UIButton, style: ButtonStyle, color: Color) {
    let colorValue = self.getColorValue(color)
    switch style {
    case .text:
      button.titleLabel?.font = self.font.body
      button.setTitleColor(colorValue, for: .normal)

    case .textBold:
      button.titleLabel?.font = self.font.bodyBold
      button.setTitleColor(colorValue, for: .normal)

    case .templateImage:
      button.tintColor = colorValue
    }
  }

  func apply(toSegmentedControl segmentedControl: UISegmentedControl) {
    segmentedControl.font      = self.font.body
    segmentedControl.tintColor = self.colorScheme.tint
  }

  func apply(toToolbar toolbar: UIToolbar) {
    toolbar.tintColor = self.colorScheme.tint
    toolbar.barStyle  = self.colorScheme.barStyle
  }

  // MARK: - Table

  func apply(toTable tableView: UITableView, separatorStyle: TableSeparatorStyle) {
    switch separatorStyle {
    case .accent:      tableView.separatorColor = self.colorScheme.backgroundAccent
    case .transparent: tableView.separatorColor = UIColor(white: 0.0, alpha: 0.0)
    }
  }

  // MARK: - Views

  func apply(toView view: UIView, style: ViewStyle) {
    switch style {
    case .alert:
      view.tintColor = self.colorScheme.tint

    case .cardPanel:
      view.backgroundColor = self.colorScheme.background
      view.roundTopCorners(radius: 8.0)

    case .cardPanelHeader:
      view.addBorder(at: .bottom)
      view.setContentHuggingPriority(900, for: .vertical)
    }
  }

  // MARK: - Private - Color value

  private func getColorValue(_ color: Color) -> UIColor {
    switch color {
    case .background:       return self.colorScheme.background
    case .backgroundAccent: return self.colorScheme.backgroundAccent
    case .text:             return self.colorScheme.text
    case .tint:             return self.colorScheme.tint
    case .bus:              return self.colorScheme.bus
    case .tram:             return self.colorScheme.tram
    }
  }
}
