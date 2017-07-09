//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol BookmarksDataSourceDelegate: class {
  func dataSource(_ dataSource: BookmarksDataSource, didDelete bookmark: Bookmark)
  func didReorderBookmarks(_ dataSource: BookmarksDataSource)
}
