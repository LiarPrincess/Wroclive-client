//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol BundleManager {

  /// App name (e.g. Kek)
  var name: String { get }

  /// App version (e.g. 1.0)
  var version: String { get }

  // App bundle (e.g. pl.kekapp.kek)
  var identifier: String { get }
}
