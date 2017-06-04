//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol BookmarksDataSourceDelegate: class {
  func didUpdateBookmarkCount(_ dataSource: BookmarksDataSource)
  func didReorderBookmarks(_ dataSource: BookmarksDataSource)
}
