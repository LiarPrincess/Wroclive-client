//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class BookmarksManagerImpl: BookmarksManager {

  // MARK: - Instructions

  private let hasSeenInstructionKey = "hasSeenBookmarkInstruction"

  var hasSeenInstruction: Bool {
    get { return UserDefaults.standard.bool(forKey: hasSeenInstructionKey) }
    set { UserDefaults.standard.set(newValue, forKey: hasSeenInstructionKey) }
  }

  // MARK: - Properties

  private lazy var bookmarks: [Bookmark] = {
    return NSKeyedUnarchiver.unarchiveObject(withFile: self.archive.path) as? [Bookmark] ?? []
  }()

  private lazy var archive: URL = {
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsDirectory.appendingPathComponent("bookmarks")
  }()

  // MARK: - Methods

  @discardableResult
  func addNew(name: String, lines: [Line]) -> Bookmark {
    let bookmark = Bookmark(name: name, lines: lines)

    var bookmarks = self.bookmarks
    bookmarks.append(bookmark)
    self.save(bookmarks)

    return bookmark
  }

  func getAll() -> [Bookmark] {
    return self.bookmarks
  }

  func save(_ bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
    NSKeyedArchiver.archiveRootObject(bookmarks, toFile: self.archive.path)
  }

}
