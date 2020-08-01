// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// MARK: - Manager type

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

// MARK: - Manager

// TODO: Handle errors somehow?
public struct StorageManager: StorageManagerType {

  private let bookmarksFile: URL
  private let searchCardStateFile: URL
  private let fileSystem: FileSystemType

  public init(fileSystem: FileSystemType) {
    self.fileSystem = fileSystem

    let documents = self.fileSystem.documentsDirectory
    self.bookmarksFile = documents.appendingPathComponent("bookmarks")
    self.searchCardStateFile = documents.appendingPathComponent("searchCardState")
  }

  public func getSavedBookmarks() -> [Bookmark]? {
    do {
      let decoder = self.createDecoder()
      let data = try self.fileSystem.read(url: self.bookmarksFile)
      return try decoder.decode([Bookmark].self, from: data)
    }
    catch { return nil }
  }

  public func getSavedSearchCardState() -> SearchCardState? {
    do {
      let decoder = self.createDecoder()
      let data = try self.fileSystem.read(url: self.searchCardStateFile)
      return try decoder.decode(SearchCardState.self, from: data)
    }
    catch { return nil }
  }

  public func saveBookmarks(_ bookmarks: [Bookmark]) {
    do {
      let encoder = self.createEncoder()
      let data = try encoder.encode(bookmarks)
      try self.fileSystem.write(url: self.bookmarksFile, data: data)
    }
    catch { }
  }

  public func saveSearchCardState(_ state: SearchCardState) {
    do {
      let encoder = self.createEncoder()
      let data = try encoder.encode(state)
      try self.fileSystem.write(url: self.searchCardStateFile, data: data)
    }
    catch { }
  }

  private func createDecoder() -> JSONDecoder {
    return JSONDecoder()
  }

  private func createEncoder() -> JSONEncoder {
    return JSONEncoder()
  }
}
