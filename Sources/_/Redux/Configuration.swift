//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import ReSwift

fileprivate let reducers: [AnyReducer] = [UserTrackingReducer(), LineSelectionReducer(), BookmarksReducer()]
fileprivate let middlewares: [Middleware] = [loggingMiddleware]

let store = Store<AppState>(reducer: CombinedReducer(reducers), state: .initial, middleware: middlewares)


//MARK: - Initial state

extension AppState {
  static var initial: AppState {
    let line6 = Line(name: "6", type: .tram)
    let line9 = Line(name: "9", type: .tram)
    let line11 = Line(name: "11", type: .tram)
    let line13 = Line(name: "13", type: .tram)
    let line15 = Line(name: "15", type: .tram)
    let line23 = Line(name: "23", type: .tram)
    let line87 = Line(name: "87", type: .tram)
    let line91 = Line(name: "91", type: .tram)
    let line139 = Line(name: "139", type: .tram)
    let line176 = Line(name: "176", type: .tram)
    let tramLines = [line6, line9, line11, line13, line15, line23, line87, line91, line139, line176]

    let lineN9 = Line(name: "N9", type: .bus)
    let lineN11 = Line(name: "N11", type: .bus)
    let lineN13 = Line(name: "N13", type: .bus)
    let lineN15 = Line(name: "N15", type: .bus)
    let lineN21 = Line(name: "N21", type: .bus)
    let lineN26 = Line(name: "N26", type: .bus)
    let lineN44 = Line(name: "N44", type: .bus)
    let lineN47 = Line(name: "N47", type: .bus)
    let lineN87 = Line(name: "N87", type: .bus)
    let lineN89 = Line(name: "N89", type: .bus)
    let lineN91 = Line(name: "N91", type: .bus)
    let lineN155 = Line(name: "N155", type: .bus)
    let lineN343 = Line(name: "N343", type: .bus)
    let lineN551 = Line(name: "N551", type: .bus)
    let busLines = [lineN9, lineN11, lineN13, lineN15, lineN21, lineN26, lineN44, lineN47, lineN87, lineN89, lineN91, lineN155, lineN343, lineN551]

    let allLines = tramLines + busLines

    var result = AppState()
    result.lineSelectionState.filteredLines = tramLines
    result.lineSelectionState.availableLines = allLines
    result.bookmarksState.bookmarks.append(Bookmark(name: "Savoy St", lines: allLines))
    result.bookmarksState.bookmarks.append(Bookmark(name: "Savoy St", lines: allLines))
    return result
  }
}
