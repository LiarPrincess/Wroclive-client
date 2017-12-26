//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias TextStyles   = LineTypeSelectorConstants.TextStyles
private typealias Localization = Localizable.LineTypeSelection

class LineTypeSelector: UISegmentedControl {

  // MARK: - Properties

  var value: ControlProperty<LineType> {
    return self.rx.controlProperty(
      editingEvents: [.allEditingEvents, .valueChanged],
      getter: { selector        in valueAt(selector.selectedSegmentIndex) },
      setter: { selector, value in selector.selectedSegmentIndex = indexOf(value) }
    )
  }

  /// Unitl 'Search' is not fully moved to Rx
  var rawValue: LineType {
    get { return valueAt(self.selectedSegmentIndex) }
    set { self.selectedSegmentIndex = indexOf(newValue) }
  }

  // MARK: - Init

  init() {
    super.init(frame: .zero)

    self.setTitleTextAttributes(TextStyles.title.value, for: .normal)
    self.insertSegment(withTitle: Localization.tram, at: Indices.tram, animated: false)
    self.insertSegment(withTitle: Localization.bus,  at: Indices.bus,  animated: false)
    self.rawValue = .tram
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
