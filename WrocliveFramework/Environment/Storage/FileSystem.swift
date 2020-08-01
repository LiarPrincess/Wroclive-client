// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol FileSystemType {

  // Get the directory where we store user data
  var documentsDirectory: URL { get }

  // Read file from disc
  func read(url: URL) throws -> Data

  // Write file to disc
  func write(url: URL, data: Data) throws
}

public struct FileSystem: FileSystemType {

  public var documentsDirectory: URL {
    let fm = FileManager()
    let documents = fm.urls(for: .documentDirectory, in: .userDomainMask)
    return documents.first!
  }

  public init() { }

  public func read(url: URL) throws -> Data {
    precondition(url.isFileURL)
    return try Data(contentsOf: url)
  }

  public func write(url: URL, data: Data) throws {
    precondition(url.isFileURL)
    try data.write(to: url, options: .atomicWrite)
  }
}
