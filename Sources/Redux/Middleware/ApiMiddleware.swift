// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

func createApiMiddleware(api: ApiManagerType) -> Middleware<AppState> {
  return { dispatch, getState in
    return { next in
      return { action in
        switch action {
        case ApiAction.updateLines: updateLines(api, dispatch)
        default: next(action)
        }
      }
    }
  }
}

// TODO: [ApiMiddleware] map no lines to error
// TODO: [ApiMiddleware] error after 3 failures
private func updateLines(_ api: ApiManagerType, _ dispatch: @escaping DispatchFunction) {
  dispatch(ApiResponseAction.setLines(.inProgress))

  let deadlineTime = DispatchTime.now() + .seconds(1)
  DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
    let lines = dummyLines()
    dispatch(ApiResponseAction.setLines(.data(lines)))
  }
}

private func dummyLines() -> [Line] {
    let line0 = Line(name:  "1", type: .tram, subtype: .regular)
    let line1 = Line(name:  "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name:  "A", type:  .bus, subtype: .regular)
    let line4 = Line(name:  "D", type:  .bus, subtype: .regular)
    return [line0, line1, line2, line3, line4]
}
