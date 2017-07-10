//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

fileprivate struct Indices {
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

  // MARK: - Init

  init() {
    super.init(items: nil) // will call init(frame:)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.insertSegment(withTitle: "Trams", at: Indices.tram, animated: false)
    self.insertSegment(withTitle: "Buses", at: Indices.bus,  animated: false)

    self.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    self.value = .tram
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
    self.delegate?.lineTypeSelectionControl(control: self, didSelect: self.value)
  }

}