// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import Foundation

public struct TextReplacement {
  public let text: String
  public let value: NSAttributedString

  public init(_ text: String, _ value: NSAttributedString) {
    self.text = text
    self.value = value
  }
}

extension NSAttributedString {

  public func withReplacements(_ replacements: [TextReplacement]) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: self)
    for (position, replacement) in self.find(replacements) {
      result.replaceCharacters(in: position, with: replacement.value)
    }

    return result
  }

  private typealias ReplacementPosition = (position: NSRange, replacement: TextReplacement)

  private func find(_ replacements: [TextReplacement]) -> [ReplacementPosition] {
    let nsString = NSString(string: self.string)
    let replacedTexts = replacements.map { $0.text }

    return self.string
      .indices(of: replacedTexts)
      .map { ($0, nsString.substring(with: $0)) }
      .compactMap { position, substring in
        replacements
          .first { $0.text.caseInsensitiveCompare(substring) == .orderedSame }
          .map { (position, $0) }
      }
  }
}
