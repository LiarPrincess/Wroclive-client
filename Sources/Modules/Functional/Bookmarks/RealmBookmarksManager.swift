//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import RealmSwift

class RealmBookmarksManager: BookmarksManager {

  // MARK: - Properties

  private let realm: Realm

  // MARK: - Init

  init() {
    do {
      self.realm = try Realm()
    } catch let error {
      fatalError(error.localizedDescription)
    }
  }

  // MARK: - Add new

  @discardableResult
  func addNew(name: String, lines: [Line]) -> Bookmark {
    do {
      let bookmarkObject = self.createNewBookmarkObject(name: name, lines: lines)

      try self.realm.write {
        self.realm.add(bookmarkObject)
      }

      return Bookmark(realmObject: bookmarkObject)
    }
    catch let error {
      fatalError(error.localizedDescription)
    }
  }

  private func createNewBookmarkObject(name: String, lines: [Line]) -> BookmarkObject {
    let maxOrder = self.realm.objects(BookmarkObject.self).max(ofProperty: "order") ?? 0

    let result   = BookmarkObject()
    result.name  = name
    result.order = maxOrder + 1
    result.lines.append(objectsIn: lines.map { line in
      let bookmarkLineObject     = BookmarkLineObject()
      // bookmarkLineObject.id   = default
      bookmarkLineObject.name    = line.name
      bookmarkLineObject.type    = line.type.rawValue
      bookmarkLineObject.subtype = line.subtype.rawValue
      return bookmarkLineObject
    })

    return result
  }

  // MARK: - Get all

  func getAll() -> [Bookmark] {
    let bookmarkObjects = self.realm.objects(BookmarkObject.self)
    return bookmarkObjects.map { Bookmark(realmObject: $0) }
  }

  // MARK: - Save

  func save(_ bookmarks: [Bookmark]) {
    do {
      let bookmarkObjects = bookmarks.map { BookmarkObject(bookmark: $0) }

      try self.realm.write {
        self.realm.add(bookmarkObjects, update: true)
      }
    }
    catch let error {
      fatalError(error.localizedDescription)
    }
  }

  // MARK: - Delete

  func delete(_ bookmark: Bookmark) {
    guard let bookmarkObject = self.realm.object(ofType: BookmarkObject.self, forPrimaryKey: bookmark.id) else {
      return
    }

    do {
      try self.realm.write {
        self.realm.delete(bookmarkObject)
      }
    } catch let error {
      fatalError(error.localizedDescription)
    }
  }

}
