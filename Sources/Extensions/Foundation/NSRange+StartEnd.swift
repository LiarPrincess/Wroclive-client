//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

extension NSRange {

  var start: Int { return self.location }
  var end:   Int { return self.location + self.length }

  init(start: Int, finish: Int) {
    assert(finish >= start)
    self.init(location: start, length: finish - start)
  }
}
