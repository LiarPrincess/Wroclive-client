// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol FileSystemType {

  // Get the directory where we store user data
  var documentsDirectory: URL { get }

  // Read file from disc
  func read(_ url: URL) throws -> Data

  // Write file to disc
  func write(_ data: Data, to url: URL) throws
}

public final class FileSystem: FileSystemType {

  public var documentsDirectory: URL {
    return FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  }

  public init() { }

  public func read(_ url: URL) throws -> Data {
    precondition(url.isFileURL)
    return try Data(contentsOf: url)
  }

  public func write(_ data: Data, to url: URL) throws {
    precondition(url.isFileURL)
    try data.write(to: url, options: .atomicWrite)
  }
}
