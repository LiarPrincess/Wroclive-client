//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ColorSelectionSectionViewModel {
  var name:           String { get }
  var cellViewModels: [AnyColorSelectionCellViewModel] { get }
}
