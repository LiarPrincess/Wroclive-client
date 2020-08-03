// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log

// MARK: - Manager type

public protocol StorageManagerType {

  /// Place where all data will be saved
  var documentsDirectory: URL { get }

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
  private let logManager: LogManagerType

  private var log: OSLog {
    return self.logManager.storage
  }

  public init(fileSystem: FileSystemType, log: LogManagerType) {
    self.logManager = log
    self.fileSystem = fileSystem

    let documents = self.fileSystem.documentsDirectory
    self.bookmarksFile = documents.appendingPathComponent("bookmarks")
    self.searchCardStateFile = documents.appendingPathComponent("searchCardState")
  }

  public var documentsDirectory: URL {
    return self.fileSystem.documentsDirectory
  }

  private enum ReadingProgress {
    case beforeRead
    case beforeDecode
  }

  public func getSavedBookmarks() -> [Bookmark]? {
    var state = ReadingProgress.beforeRead

    do {
      let data = try self.fileSystem.read(url: self.bookmarksFile)
      os_log("Found existing bookmarks file", log: self.log, type: .info)

      state = .beforeDecode
      let decoder = self.createDecoder()
      let result = try decoder.decode([Bookmark].self, from: data)
      os_log("Succesfully read bookmarks file", log: self.log, type: .info)

      return result
    } catch {
      switch state {
      case .beforeRead:
        os_log("Bookmark file does not exit", log: self.log, type: .info)
      case .beforeDecode:
        os_log("Bookmark file has invalid content", log: self.log, type: .error)
      }

      return nil
    }
  }

  public func getSavedSearchCardState() -> SearchCardState? {
    var state = ReadingProgress.beforeRead

    do {
      let data = try self.fileSystem.read(url: self.searchCardStateFile)
      os_log("Found existing search card state file", log: self.log, type: .info)

      state = .beforeDecode
      let decoder = self.createDecoder()
      let result = try decoder.decode(SearchCardState.self, from: data)
      os_log("Succesfully read search card state file", log: self.log, type: .info)

      return result
    } catch {
      switch state {
      case .beforeRead:
        os_log("Search card state file does not exit", log: self.log, type: .info)
      case .beforeDecode:
        os_log("Search card state file has invalid content", log: self.log, type: .error)
      }

      return nil
    }
  }

  public func saveBookmarks(_ bookmarks: [Bookmark]) {
    do {
      let encoder = self.createEncoder()
      let data = try encoder.encode(bookmarks)
      try self.fileSystem.write(url: self.bookmarksFile, data: data)
      os_log("Succesfully saved bookmarks", log: self.log, type: .info)
    } catch {
      os_log("Failed to save bookmarks", log: self.log, type: .error)
    }
  }

  public func saveSearchCardState(_ state: SearchCardState) {
    do {
      let encoder = self.createEncoder()
      let data = try encoder.encode(state)
      try self.fileSystem.write(url: self.searchCardStateFile, data: data)
      os_log("Succesfully saved search card state", log: self.log, type: .info)
    }
    catch {
      os_log("Failed to save search card state", log: self.log, type: .error)
    }
  }

  // MARK: - Decoder, encoder

  private func createDecoder() -> JSONDecoder {
    return JSONDecoder()
  }

  private func createEncoder() -> JSONEncoder {
    return JSONEncoder()
  }
}
