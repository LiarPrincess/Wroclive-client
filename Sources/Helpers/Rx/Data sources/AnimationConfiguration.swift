//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct AnimationConfiguration {
  let insert: UITableViewRowAnimation
  let delete: UITableViewRowAnimation
  let reload: UITableViewRowAnimation

  init(insert: UITableViewRowAnimation,
       delete: UITableViewRowAnimation,
       reload: UITableViewRowAnimation) {
    self.insert = insert
    self.delete = delete
    self.reload = reload
  }

  // MARK: - Default

  static var `default`: AnimationConfiguration {
    return AnimationConfiguration(insert: .automatic, delete: .automatic, reload: .automatic)
  }
}
