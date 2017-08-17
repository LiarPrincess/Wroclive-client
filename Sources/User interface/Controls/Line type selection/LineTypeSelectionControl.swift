//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

fileprivate typealias Localization = LineTypeSelectionControlConstants.Localization

private struct Indices {
  static let tram = 0
  static let bus  = 1
}

class LineTypeSelectionControl: UISegmentedControl {

  // MARK: - Properties

  weak var delegate: LineTypeSelectionControlDelegate?

  var value: LineType {
    get {
      let index = self.selectedSegmentIndex
      return index == Indices.tram ? .tram : .bus
    }
    set {
      let index = newValue == .tram ? Indices.tram : Indices.bus
      self.selectedSegmentIndex = index
      self.delegateDidSelect()
    }
  }

  /// Proposed height
  static var nominalHeight: CGFloat { return 30.0 }

  // MARK: - Init

  init() {
    super.init(items: nil) // will call init(frame:)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    let textAttributes = Theme.current.textAttributes(for: .body, color: .tint)
    self.setTitleTextAttributes(textAttributes, for: .normal)

    self.insertSegment(withTitle: Localization.tram, at: Indices.tram, animated: false)
    self.insertSegment(withTitle: Localization.bus,  at: Indices.bus,  animated: false)

    self.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func valueChanged() {
    self.delegateDidSelect()
  }

  // MARK: - Methods

  private func delegateDidSelect() {
    self.delegate?.lineTypeSelectionControl(self, didSelect: self.value)
  }

}
