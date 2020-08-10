// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public protocol StorageManagerType {

  /// Place where all data will be saved
  var documentsDirectory: URL { get }

  /// Get saved bookmarks from a file
  func readBookmarks() -> [Bookmark]?
  /// Write bookmarks to file
  func writeBookmarks(_ bookmarks: [Bookmark])

  /// Get saved tracked lines from a file
  func readTrackedLines() -> [Line]?
  /// Write tracked lines to file
  func writeTrackedLines(_ lines: [Line])

  /// Get saved search card state from a file
  func readSearchCardState() -> SearchCardState?
  /// Write search card state to file
  func writeSearchCardState(_ state: SearchCardState)
}
