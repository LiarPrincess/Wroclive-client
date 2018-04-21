//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

protocol DebugManagerType {

  #if DEBUG

  /// Clear NSURLSession cache
  func clearNetworkCache()

  /// Print Rx resource count every 1s
  func printRxResources()

  #endif
}
