//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol LineSelectionSectionCreatorProtocol {
  func create(from lines: [Line]) -> [LineSelectionSection]
}
