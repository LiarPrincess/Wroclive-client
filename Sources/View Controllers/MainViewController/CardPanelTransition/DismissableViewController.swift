//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

protocol DismissableViewController: class {
  func dismissAnimated(completion: (() -> Swift.Void)?)
}
