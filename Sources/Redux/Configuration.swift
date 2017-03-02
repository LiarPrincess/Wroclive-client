//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

fileprivate let reducers: [AnyReducer] = [UserTrackingReducer(), LineSelectionReducer(), BookmarksReducer()]
fileprivate let middlewares: [Middleware] = [loggingMiddleware]

let store = Store<AppState>(reducer: CombinedReducer(reducers), state: .initial, middleware: middlewares)
