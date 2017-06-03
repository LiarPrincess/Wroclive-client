//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct LineSelectionSectionHeaderViewModel {
  let sectionTitle: String

  init(for type: LineType, _ subtype: LineSubtype) {
    self.sectionTitle = String(describing: subtype).capitalized
  }
}
