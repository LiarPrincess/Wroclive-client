//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol BookmarksViewControllerDelegate: class {
  func bookmarksViewController(_ controller: BookmarksViewController, didSelect bookmark: Bookmark)
}
