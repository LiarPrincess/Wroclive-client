// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log

public struct StorageManager: StorageManagerType {

  private let bookmarksFile: URL
  private let trackedLinesFile: URL
  private let searchCardStateFile: URL
  private let fileSystem: FileSystemType
  private let logManager: LogManagerType

  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()

  private var log: OSLog {
    return self.logManager.storage
  }

  public init(fileSystem: FileSystemType, log: LogManagerType) {
    self.logManager = log
    self.fileSystem = fileSystem

    let documents = self.fileSystem.documentsDirectory
    self.bookmarksFile = documents.appendingPathComponent("bookmarks.json")
    self.trackedLinesFile = documents.appendingPathComponent("tracked_lines.json")
    self.searchCardStateFile = documents.appendingPathComponent("searchCardState.json")
  }

  public var documentsDirectory: URL {
    return self.fileSystem.documentsDirectory
  }

  // MARK: - Read

  public func readBookmarks() -> [Bookmark]? {
    return self.read([Bookmark].self, from: self.bookmarksFile)
  }

  public func readTrackedLines() -> [Line]? {
    return self.read([Line].self, from: self.trackedLinesFile)
  }

  public func readSearchCardState() -> SearchCardState? {
    return self.read(SearchCardState.self, from: self.searchCardStateFile)
  }

  private enum ReadingProgress {
    case beforeRead
    case beforeDecode
  }

  private func read<T: Decodable>(_ type: T.Type, from url: URL) -> T? {
    let filename = url.lastPathComponent
    os_log("Reading '%{public}@'", log: self.log, type: .info, filename)

    var state = ReadingProgress.beforeRead
    do {
      let data = try self.fileSystem.read(url: url)
      os_log("  File found", log: self.log, type: .info)

      state = .beforeDecode
      let result = try self.decoder.decode(T.self, from: data)
      os_log("  File was successfully decoded", log: self.log, type: .info)

      return result
    } catch {
      switch state {
      case .beforeRead:
        os_log("  File does not exist", log: self.log, type: .info)
      case .beforeDecode:
        os_log("  File has invalid content", log: self.log, type: .error)
      }

      return nil
    }
  }

  // MARK: - Write

  public func writeBookmarks(_ bookmarks: [Bookmark]) {
    self.write(bookmarks, to: self.bookmarksFile)
  }

  public func writeTrackedLines(_ lines: [Line]) {
    self.write(lines, to: self.trackedLinesFile)
  }

  public func writeSearchCardState(_ state: SearchCardState) {
    self.write(state, to: self.searchCardStateFile)
  }

  private func write<T: Encodable>(_ value: T, to url: URL) {
    let filename = url.lastPathComponent

    do {
      let data = try self.encoder.encode(value)
      try self.fileSystem.write(url: url, data: data)
      os_log("Succesfully written '%{public}@'", log: self.log, type: .info, filename)
    }
    catch {
      os_log("Failed to write '%{public}@'", log: self.log, type: .error, filename)
    }
  }
}
