//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Reusable

protocol ReusableCell {}

extension ReusableCell where Self: UITableViewCell  {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: ReusableCell {}

//MARK: - UITableView

extension UITableView {

  func register<T: UITableViewCell>(_ : T.Type) where T: ReusableCell {
    register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
  }

  func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableCell {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell of specified type.")
    }

    return cell
  }

}
