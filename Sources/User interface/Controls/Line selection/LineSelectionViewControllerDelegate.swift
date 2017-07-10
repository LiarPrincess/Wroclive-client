//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol LineSelectionViewControllerDelegate: class {
  func lineSelectionViewController(controller: LineSelectionViewController, didChangePage lineType: LineType)
}
