//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import MapKit
import ReSwift

//MARK: - AppState

struct AppState: StateType {
  var trackingMode: MKUserTrackingMode = .none

  var searchState = SearchState()
  var bookmarksState = BookmarksState()

}

//MARK: - Initial data

extension AppState {
  static var initial: AppState {
    let line4 = Line(name: "4", type: .tram)
    let line20 = Line(name: "20", type: .tram)

    let lineA = Line(name: "A", type: .bus)
    let line125 = Line(name: "125", type: .bus)
    let line325 = Line(name: "325", type: .bus)
    let line107 = Line(name: "107", type: .bus)

    var result = AppState()
    result.searchState.avaiableLines.append(line4)
    result.searchState.avaiableLines.append(line20)
    result.searchState.avaiableLines.append(lineA)
    result.searchState.avaiableLines.append(line125)
    result.searchState.avaiableLines.append(line325)
    result.searchState.avaiableLines.append(line107)
    result.bookmarksState.bookmarks.append(Bookmark(name: "Uczelnia", lines: [line4, line20, line125]))
    result.bookmarksState.bookmarks.append(Bookmark(name: "Praca", lines: [line4, line20, lineA, line125, line325, line107]))
    return result
  }
}
