//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RealmSwift

class BookmarkObject: Object {
  dynamic var id:    String = UUID().uuidString // swiftlint:disable:this identifier_name
  dynamic var name:  String = ""
  dynamic var order: Int    = 0

  let lines = List<BookmarkLineObject>()

  override static func primaryKey() -> String? {
    return "id"
  }
}

extension BookmarkObject {
  convenience init(bookmark: Bookmark) {
    self.init()

    let lineObjects = bookmark.lines.map { BookmarkLineObject(line: $0) }

    self.id    = bookmark.id
    self.name  = bookmark.name
    self.order = bookmark.order
    self.lines.append(objectsIn: lineObjects)
  }
}

extension Bookmark {
  init(realmObject: BookmarkObject) {
    self.id    = realmObject.id
    self.name  = realmObject.name
    self.order = realmObject.order
    self.lines = realmObject.lines.map { BookmarkLine(realmObject: $0) }
  }
}
