// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public protocol StorageManagerType {

  /// Get saved bookmarks from a file
  func getSavedBookmarks() -> [Bookmark]?

  /// Get saved search card state from a file
  func getSavedSearchCardState() -> SearchCardState?

  /// Write bookmarks to file
  func saveBookmarks(_ bookmarks: [Bookmark])

  /// Write saved search card state to file
  func saveSearchCardState(_ state: SearchCardState)
}

// sourcery: manager
public final class StorageManager: StorageManagerType {

  private var bookmarksFile: URL {
    let documentsDir = self.fileSystem.documentsDirectory
    return documentsDir.appendingPathComponent("bookmarks")
  }

  private var searchCardStateFile: URL {
    let documentsDir = self.fileSystem.documentsDirectory
    return documentsDir.appendingPathComponent("searchCardState")
  }

  private let fileSystem: FileSystemType

  public init(fileSystem: FileSystemType = FileSystem()) {
    self.fileSystem = fileSystem
  }

  // MARK: - StorageManagerType

  public func getSavedBookmarks() -> [Bookmark]? {
    do {
      let decoder = self.createDecoder()
      let data = try self.fileSystem.read(self.bookmarksFile)
      return try decoder.decode([Bookmark].self, from: data)
    }
    catch { return nil }
  }

  public func getSavedSearchCardState() -> SearchCardState? {
    do {
      let decoder = self.createDecoder()
      let data = try self.fileSystem.read(self.searchCardStateFile)
      return try decoder.decode(SearchCardState.self, from: data)
    }
    catch { return nil }
  }

  public func saveBookmarks(_ bookmarks: [Bookmark]) {
    do {
      let encoder = self.createEncoder()
      let data = try encoder.encode(bookmarks)
      try self.fileSystem.write(data, to: self.bookmarksFile)
    }
    catch { }
  }

  public func saveSearchCardState(_ state: SearchCardState) {
    do {
      let encoder = self.createEncoder()
      let data = try encoder.encode(state)
      try self.fileSystem.write(data, to: self.searchCardStateFile)
    }
    catch { }
  }

  // MARK: - Helpers

  private func createDecoder() -> PropertyListDecoder {
    return PropertyListDecoder()
  }

  private func createEncoder() -> PropertyListEncoder {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    return encoder
  }
}
