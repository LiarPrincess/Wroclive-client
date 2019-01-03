// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public final class FileSystem {

  public func read(_ document: Document) -> Any? {
    do {
      let url  = self.getDocumentURL(document)
      let data = try Data(contentsOf: url)
      return try self.decode(document, from: data)
    }
    catch { return nil }
  }

  public func write(_ documentData: DocumentData) {
    do {
      let url  = self.getDocumentURL(documentData.document)
      let data = try self.encode(documentData)
      try data.write(to: url, options: .atomicWrite)
    }
    catch { }
  }

  // MARK: - Decode/Encode

  private func decode(_ document: Document, from data: Data) throws -> Any? {
    let decoder = PropertyListDecoder()

    switch document {
    case .bookmarks:       return try decoder.decode([Bookmark].self,      from: data)
    case .searchCardState: return try decoder.decode(SearchCardState.self, from: data)
    }
  }

  private func encode(_ documentData: DocumentData) throws -> Data {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml

    // Swift 4 forces us to use concrete type when encoding not an generic Encodable
    switch documentData {
    case let .bookmarks(value):       return try encoder.encode(value)
    case let .searchCardState(value): return try encoder.encode(value)
    }
  }

  // MARK: - URL

  private func getDocumentURL(_ document: Document) -> URL {
    let filename = self.getDocumentFilename(document)
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsDirectory.appendingPathComponent(filename)
  }

  private func getDocumentFilename(_ document: Document) -> String {
    switch document {
    case .bookmarks:       return "bookmarks"
    case .searchCardState: return "searchCardState"
    }
  }
}
