//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol SearchViewControllerDelegate: class {
  func searchViewController(_ controller: SearchViewController, didSelect lines: [Line])
}
