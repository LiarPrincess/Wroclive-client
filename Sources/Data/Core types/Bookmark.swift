//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation

struct Bookmark {
  let name: String
  let lines: [Line]
}

extension Bookmark: CustomStringConvertible {
  var description: String { return "(\(self.name), \(self.lines))" }
}

extension Bookmark: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
