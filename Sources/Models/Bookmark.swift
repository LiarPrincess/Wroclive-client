//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct Bookmark: Codable, Equatable {
  let name:  String
  let lines: [Line]
}
