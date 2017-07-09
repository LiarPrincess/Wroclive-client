//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol LineSelectionControlDelegate: class {
  func control(_ control: LineSelectionControl, didSelect   line: Line)
  func control(_ control: LineSelectionControl, didDeselect line: Line)
}

extension LineSelectionControlDelegate {
  func control(_ control: LineSelectionControl, didSelect   line: Line) { }
  func control(_ control: LineSelectionControl, didDeselect line: Line) { }
}
