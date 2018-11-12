// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

func createApiMiddleware(api: ApiManagerType) -> Middleware<AppState> {
  return { dispatch, getState in
    return { next in
      return { action in
        guard let state = getState()
          else { return }

        switch action {
        case ApiAction.updateLines: updateLines(api, dispatch)
        case ApiAction.updateVehicleLocations: updateVehicleLocations(api, state.userData.trackedLines, dispatch)
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
    let data = dummyLines()
    dispatch(ApiResponseAction.setLines(.data(data)))
  }
}

private func updateVehicleLocations(_ api: ApiManagerType, _ lines: [Line], _ dispatch: @escaping DispatchFunction) {
  dispatch(ApiResponseAction.setVehicleLocations(.inProgress))

  let deadlineTime = DispatchTime.now() + .seconds(1)
  DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
    let data = dummyVehicles()
    dispatch(ApiResponseAction.setVehicleLocations(.data(data)))
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

private func dummyVehicles() -> [Vehicle] {
  let line0 = Line(name:  "1", type: .tram, subtype: .regular)
  let line1 = Line(name:  "4", type: .tram, subtype: .regular)
  let line2 = Line(name: "20", type: .tram, subtype: .regular)
  let line3 = Line(name:  "A", type:  .bus, subtype: .regular)
  let line4 = Line(name:  "D", type:  .bus, subtype: .regular)

  return [
    Vehicle(id: "0", line: line0, latitude: 0.0, longitude: 0.0, angle: 0.0),
    Vehicle(id: "1", line: line1, latitude: 1.0, longitude: 1.0, angle: 1.0),
    Vehicle(id: "2", line: line2, latitude: 2.0, longitude: 2.0, angle: 2.0),
    Vehicle(id: "3", line: line3, latitude: 3.0, longitude: 3.0, angle: 3.0),
    Vehicle(id: "4", line: line4, latitude: 4.0, longitude: 4.0, angle: 4.0)
  ]
}
