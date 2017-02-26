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

  var bookmarksState = BookmarksState()
}

//MARK: - BookmarksState

struct BookmarksState: StateType {
  var visible = false
  var bookmarks = [Bookmark]()
}

//MARK: - Initial data

extension AppState {
  static var initial: AppState {
    let line4 = Line(name: "4", vechicleType: .tram)
    let line20 = Line(name: "20", vechicleType: .tram)

    let lineA = Line(name: "A", vechicleType: .bus)
    let line125 = Line(name: "125", vechicleType: .bus)
    let line325 = Line(name: "325", vechicleType: .bus)
    let line107 = Line(name: "107", vechicleType: .bus)

    var result = AppState()
    result.bookmarksState.bookmarks.append(Bookmark(name: "Uczelnia", lines: [line4, line20, line125]))
    result.bookmarksState.bookmarks.append(Bookmark(name: "Praca", lines: [line4, line20, lineA, line125, line325, line107]))
    return result
  }
}
