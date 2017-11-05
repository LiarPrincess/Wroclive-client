//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import PromiseKit

class ApiManagerMockup: ApiManager {

  private let lines:    [Line]
  private let vehicles: [Vehicle]

  fileprivate init(lines: [Line], vehicles: [Vehicle]) {
    self.lines    = lines
    self.vehicles = vehicles
  }

  func getAvailableLines()  -> Promise<[Line]> {
    return Promise(value: self.lines)
  }

  func getVehicleLocations(for lines: [Line]) -> Promise<[Vehicle]> {
    return Promise(value: [])
  }
}

extension ApiManagerMockup {

  static var empty: ApiManagerMockup {
    return ApiManagerMockup(lines: [], vehicles: [])
  }

  static var filled: ApiManagerMockup {
    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram3 = Line(name: "3", type: .tram, subtype: .regular)
    let tram4 = Line(name: "4", type: .tram, subtype: .regular)
    let tram5 = Line(name: "5", type: .tram, subtype: .regular)
    let busA  = Line(name: "A", type: .bus, subtype: .express)
    let busC  = Line(name: "C", type: .bus, subtype: .express)
    let busD  = Line(name: "D", type: .bus, subtype: .express)
    let tram0L = Line(name: "0L", type: .tram, subtype: .regular)
    let tram0P = Line(name: "0P", type: .tram, subtype: .regular)
    let tram10 = Line(name: "10", type: .tram, subtype: .regular)
    let tram11 = Line(name: "11", type: .tram, subtype: .regular)
    let tram14 = Line(name: "14", type: .tram, subtype: .regular)
    let tram20 = Line(name: "20", type: .tram, subtype: .regular)
    let tram24 = Line(name: "24", type: .tram, subtype: .regular)
    let tram31 = Line(name: "31", type: .tram, subtype: .regular)
    let tram32 = Line(name: "32", type: .tram, subtype: .regular)
    let tram33 = Line(name: "33", type: .tram, subtype: .regular)
    let bus107 = Line(name: "107", type: .bus, subtype: .regular)
    let bus125 = Line(name: "125", type: .bus, subtype: .regular)
    let bus126 = Line(name: "126", type: .bus, subtype: .regular)
    let bus134 = Line(name: "134", type: .bus, subtype: .regular)
    let bus136 = Line(name: "136", type: .bus, subtype: .regular)
    let bus145 = Line(name: "145", type: .bus, subtype: .regular)
    let bus146 = Line(name: "146", type: .bus, subtype: .regular)
    let bus149 = Line(name: "149", type: .bus, subtype: .regular)
    let bus241 = Line(name: "241", type: .bus, subtype: .night)
    let bus246 = Line(name: "246", type: .bus, subtype: .night)
    let bus248 = Line(name: "248", type: .bus, subtype: .night)
    let bus251 = Line(name: "251", type: .bus, subtype: .night)
    let bus257 = Line(name: "257", type: .bus, subtype: .night)
    let bus319 = Line(name: "319", type: .bus, subtype: .regular)
    let bus325 = Line(name: "325", type: .bus, subtype: .regular)

    let lines: [Line] = [tram1, tram3, tram4, tram5, busA, busC, busD, tram0L, tram0P, tram10, tram11, tram14, tram20, tram24, tram31, tram32, tram33, bus107, bus125, bus126, bus134, bus136, bus145, bus146, bus149, bus241, bus246, bus248, bus251, bus257, bus319, bus325]
    return ApiManagerMockup(lines: lines, vehicles: [])
  }
}
