//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol BookmarksDataSourceDelegate: class {
  func bookmarksDataSource(_ dataSource: BookmarksDataSource, didChangeRowCount rowCount: Int)
}
