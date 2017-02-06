//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation

class MapControllerMock: MapControllerProtocol {

  //MARK: - MapControllerProtocol

  func centerOnUserLocation() {
    log("centerOnUserLocation")
  }

  fileprivate func log(_ msg: String) {
    print("[MapControllerMock] \(msg)")
  }
}
