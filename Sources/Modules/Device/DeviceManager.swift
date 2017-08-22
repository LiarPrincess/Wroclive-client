//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol DeviceManager {

  /// iPhone, iPod touch
  var model: String { get }

  /// iOS, watchOS, tvOS
  var systemName: String { get }

  /// 10.2
  var systemVersion: String { get }
}
