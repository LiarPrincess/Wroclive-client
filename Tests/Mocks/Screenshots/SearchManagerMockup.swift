////
////  Created by Michal Matuszczyk
////  Copyright © 2017 Michal Matuszczyk. All rights reserved.
////
//
//import UIKit
//
//class SearchManagerMockup: SearchManager {
//
//  private var state: SearchState
//
//  fileprivate init(state: SearchState) {
//    self.state = state
//  }
//
//  func saveState(_ state: SearchState) {
//    self.state = state
//  }
//
//  func getSavedState() -> SearchState {
//    return self.state
//  }
//}
//
//extension SearchManagerMockup {
//
//  static var empty: SearchManagerMockup {
//    let state = SearchState(withSelected: .tram, lines: [])
//    return SearchManagerMockup(state: state)
//  }
//
//  static var someSelected: SearchManagerMockup {
//    let tram3 = Line(name: "3", type: .tram, subtype: .regular)
//    let tram4 = Line(name: "4", type: .tram, subtype: .regular)
//    let tram5 = Line(name: "5", type: .tram, subtype: .regular)
//    let busA  = Line(name: "A", type: .bus, subtype: .express)
//    let tram0L = Line(name: "0L", type: .tram, subtype: .regular)
//    let tram0P = Line(name: "0P", type: .tram, subtype: .regular)
//    let tram10 = Line(name: "10", type: .tram, subtype: .regular)
//    let bus146 = Line(name: "146", type: .bus, subtype: .regular)
//    let bus149 = Line(name: "149", type: .bus, subtype: .regular)
//    let bus241 = Line(name: "241", type: .bus, subtype: .night)
//    let bus319 = Line(name: "319", type: .bus, subtype: .regular)
//    let bus325 = Line(name: "325", type: .bus, subtype: .regular)
//
//    let selectedLines: [Line] = [tram3, tram4, tram5, busA, tram0L, tram0P, tram10, bus146, bus149, bus241, bus319, bus325]
//    let state = SearchState(withSelected: .tram, lines: selectedLines)
//    return SearchManagerMockup(state: state)
//  }
//}
