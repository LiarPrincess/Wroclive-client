//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias TextStyles   = LineTypeSelectorConstants.TextStyles
private typealias Localization = Localizable.Search

class LineTypeSelector: UISegmentedControl {

  // MARK: - Properties

  var selectedValue: LineType {
    get { return valueAt(self.selectedSegmentIndex) }
    set { self.selectedSegmentIndex = indexOf(newValue) }
  }

  // MARK: - Init

  init() {
    super.init(frame: .zero)

    self.setTitleTextAttributes(TextStyles.title.value, for: .normal)
    self.insertSegment(withTitle: Localization.Pages.tram, at: Indices.tram, animated: false)
    self.insertSegment(withTitle: Localization.Pages.bus,  at: Indices.bus,  animated: false)
    self.selectedValue = .tram
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Indices

private struct Indices {
  static let tram = 0
  static let bus  = 1
}

private func indexOf(_ lineType: LineType) -> Int {
  switch lineType {
  case .tram: return Indices.tram
  case .bus:  return Indices.bus
  }
}

private func valueAt(_ index: Int) -> LineType {
  switch index {
  case Indices.tram: return .tram
  case Indices.bus:  return .bus
  default: fatalError("Invalid index selected")
  }
}
