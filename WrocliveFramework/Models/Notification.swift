// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public struct Notification: Codable, Equatable, CustomStringConvertible {

  public let id: String
  public let url: String
  public let author: String
  public let date: Date
  public let body: String

  public var description: String {
    let body = self.body.prefix(30) + "…"
    return "Notification(\(self.id) at \(self.date) by \(self.author): \(body)"
  }

  public init(id: String, url: String, author: String, date: Date, body: String) {
    self.id = id
    self.url = url
    self.author = author
    self.date = date
    self.body = body
  }
}
