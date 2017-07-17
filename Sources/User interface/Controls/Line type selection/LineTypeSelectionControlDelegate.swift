//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol LineTypeSelectionControlDelegate: class {

  /// Called after selection changed (programatically or by touch event)
  func lineTypeSelectionControl(_ control: LineTypeSelectionControl, didSelect lineType: LineType)

}
