//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

struct TextReplacement {
  let text:  String
  let value: NSAttributedString

  init(_ text: String, _ value: NSAttributedString) {
    self.text  = text
    self.value = value
  }
}

extension NSAttributedString {

  func withReplacements(_ replacements: [TextReplacement]) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: self)
    for (position, replacement) in self.findReplacementPositions(replacements) {
      result.replaceCharacters(in: position, with: replacement.value)
    }

    return result
  }

  private typealias ReplacementPosition = (position: NSRange, replacement: TextReplacement)

  private func findReplacementPositions(_ replacements: [TextReplacement]) -> [ReplacementPosition] {
    let nsString = NSString(string: self.string)
    let replacedTexts = replacements.map { $0.text }

    return self.string
      .indices(of: replacedTexts)
      .map     { ($0, nsString.substring(with: $0)) }
      .flatMap { position, substring in
        replacements
          .first { $0.text.caseInsensitiveCompare(substring) == .orderedSame }
          .map   { (position, $0) }
      }
  }
}
