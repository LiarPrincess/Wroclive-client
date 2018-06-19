//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct SearchCardState: Codable, Equatable {
  let page:          LineType
  let selectedLines: [Line]
}
