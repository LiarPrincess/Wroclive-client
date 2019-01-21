// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum LineSelectorSectionCreator {

  public static func create(_ lines: [Line]) -> [LineSelectorSection] {
    return lines
      .group(by: { $0.subtype })
      .map(createSection)
      .sorted { getOrder(subtype: $0.model.lineSubtype) < getOrder(subtype: $1.model.lineSubtype) }
  }

  private static func createSection(subtype lineSubtype: LineSubtype, lines: [Line]) -> LineSelectorSection {
    let data = LineSelectorSectionData(for: lineSubtype)
    return LineSelectorSection(model: data, items: lines.sortedByName())
  }

  private static func getOrder(subtype lineSubtype: LineSubtype) -> Int {
    switch lineSubtype {
    case .express:   return 0
    case .regular:   return 1
    case .night:     return 2
    case .suburban:  return 3
    case .peakHour:  return 4
    case .zone:      return 5
    case .limited:   return 6
    case .temporary: return 7
    }
  }
}
