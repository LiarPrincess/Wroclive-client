// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

enum LineSelectorTestData {

  internal static let lines = LineSelectorTestData.data.lines
  internal static let tramLines = LineSelectorTestData.data.tramLines
  internal static let busLines = LineSelectorTestData.data.busLines

  internal static let tramSections = LineSelectorTestData.data.tramSections
  internal static let busSections = LineSelectorTestData.data.busSections

  private typealias Data = (
    lines: [Line],
    tramLines: [Line],
    busLines: [Line],
    tramSections: [LineSelectorSection],
    busSections: [LineSelectorSection]
  )

  // swiftlint:disable:next closure_body_length
  private static var data: Data = {
    let line0 = Line(name: "0", type: .tram, subtype: .express)
    let line1 = Line(name: "1", type: .tram, subtype: .express)
    let line2 = Line(name: "2", type: .tram, subtype: .regular)
    let line3 = Line(name: "3", type: .bus, subtype: .regular)
    let line4 = Line(name: "4", type: .bus, subtype: .night)
    let line5 = Line(name: "5", type: .bus, subtype: .suburban)
    let line6 = Line(name: "6", type: .bus, subtype: .peakHour)
    let line7 = Line(name: "7", type: .bus, subtype: .zone)
    let line8 = Line(name: "8", type: .bus, subtype: .limited)
    let line9 = Line(name: "9", type: .bus, subtype: .temporary)
    let line10 = Line(name: "10", type: .bus, subtype: .express)
    let line11 = Line(name: "11", type: .bus, subtype: .express)

    // To make it more complicated reverse list
    let lines = [
      line0, line1, line2, line3, line4,
      line5, line6, line7, line8, line9,
      line10, line11
    ].reversed()

    let tramLines = Array(lines.filter { $0.type == .tram })
    let busLines = Array(lines.filter { $0.type == .bus })

    let tramSections = [
      LineSelectorSection(subtype: .express, lines: [line0, line1]),
      LineSelectorSection(subtype: .regular, lines: [line2])
    ]

    let busSections = [
      LineSelectorSection(subtype: .express, lines: [line10, line11]),
      LineSelectorSection(subtype: .regular, lines: [line3]),
      LineSelectorSection(subtype: .night, lines: [line4]),
      LineSelectorSection(subtype: .suburban, lines: [line5]),
      LineSelectorSection(subtype: .peakHour, lines: [line6]),
      LineSelectorSection(subtype: .zone, lines: [line7]),
      LineSelectorSection(subtype: .limited, lines: [line8]),
      LineSelectorSection(subtype: .temporary, lines: [line9])
    ]

    return (
      lines: Array(lines),
      tramLines: tramLines,
      busLines: busLines,
      tramSections: tramSections,
      busSections: busSections
    )
  }()
}
