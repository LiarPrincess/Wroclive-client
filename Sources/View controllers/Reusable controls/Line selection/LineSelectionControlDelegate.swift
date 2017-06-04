//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol LineSelectionControlDelegate: class {
  func lineSelectionControl(_ control: LineSelectionControl, didSelect   line: Line)
  func lineSelectionControl(_ control: LineSelectionControl, didDeselect line: Line)
}
