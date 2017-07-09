//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RealmSwift

class BookmarkLineObject: Object {
  dynamic var id:      String = UUID().uuidString
  dynamic var name:    String = ""
  dynamic var type:    Int    = 0
  dynamic var subtype: Int    = 0

  override static func primaryKey() -> String? {
    return "id"
  }
}

extension BookmarkLineObject {
  convenience init(line: BookmarkLine) {
    self.init()
    self.id      = line.id
    self.name    = line.name
    self.type    = line.type.rawValue
    self.subtype = line.subtype.rawValue
  }
}

extension BookmarkLine {
  init(realmObject: BookmarkLineObject) {
    self.id      = realmObject.id
    self.name    = realmObject.name
    self.type    = LineType(rawValue: realmObject.type)!
    self.subtype = LineSubtype(rawValue: realmObject.subtype)!
  }
}
