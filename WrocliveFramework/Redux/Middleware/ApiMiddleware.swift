// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

// swiftlint:disable implicit_return

public func createApiMiddleware(env: Environment) -> Middleware<AppState> {
  return { dispatch, getState in
    return { next in
      return { action in

        guard let state = getState()
          else { return }

        switch action {
        case ApiAction.updateLines:
          requestLines(env: env, dispatch: dispatch)
        case ApiAction.updateVehicleLocations:
          requestVehicleLocations(env: env, state: state, dispatch: dispatch)
        default: next(action)
        }
      }
    }
  }
}

private func requestLines(
  env: Environment,
  dispatch: @escaping DispatchFunction
) {
  dispatch(ApiResponseAction.setLines(.inProgress))

  let delay = DispatchTime.now() + .seconds(1)
  DispatchQueue.main.asyncAfter(deadline: delay) {
    let data = dummyLines()
    dispatch(ApiResponseAction.setLines(.data(data)))
  }
}

private func requestVehicleLocations(
  env: Environment,
  state: AppState,
  dispatch: @escaping DispatchFunction
) {
  let trackedLines = state.userData.trackedLines

  guard trackedLines.any else {
    dispatch(ApiResponseAction.setVehicleLocations(.data([])))
    return
  }

  dispatch(ApiResponseAction.setVehicleLocations(.inProgress))

  let delay = DispatchTime.now() + .seconds(1)
  DispatchQueue.main.asyncAfter(deadline: delay) {
    if case let .data(vehicles) = state.apiData.vehicleLocations, vehicles.any {
      let newVehicles = vehicles.map { rotate(vehicle: $0, degrees: 30) }
      dispatch(ApiResponseAction.setVehicleLocations(.data(newVehicles)))
      return
    }

    let data = dummyVehicles()
    dispatch(ApiResponseAction.setVehicleLocations(.data(data)))
  }
}

private func rotate(vehicle: Vehicle, degrees: Double) -> Vehicle {
  return Vehicle(id: vehicle.id,
                 line: vehicle.line,
                 latitude: vehicle.latitude,
                 longitude: vehicle.longitude,
                 angle: vehicle.angle + degrees)
}

// swiftlint:disable:next function_body_length
private func dummyLines() -> [Line] {
  return [
    Line(name: "1", type: .tram, subtype: .regular),
    Line(name: "2", type: .tram, subtype: .regular),
    Line(name: "3", type: .tram, subtype: .regular),
    Line(name: "4", type: .tram, subtype: .regular),
    Line(name: "5", type: .tram, subtype: .regular),
    Line(name: "6", type: .tram, subtype: .regular),
    Line(name: "7", type: .tram, subtype: .regular),
    Line(name: "8", type: .tram, subtype: .regular),
    Line(name: "9", type: .tram, subtype: .regular),
    Line(name: "A", type: .bus, subtype: .express),
    Line(name: "D", type: .bus, subtype: .express),
    Line(name: "K", type: .bus, subtype: .express),
    Line(name: "N", type: .bus, subtype: .express),
    Line(name: "0L", type: .tram, subtype: .regular),
    Line(name: "0P", type: .tram, subtype: .regular),
    Line(name: "10", type: .tram, subtype: .regular),
    Line(name: "11", type: .tram, subtype: .regular),
    Line(name: "14", type: .tram, subtype: .regular),
    Line(name: "15", type: .tram, subtype: .regular),
    Line(name: "17", type: .tram, subtype: .regular),
    Line(name: "20", type: .tram, subtype: .regular),
    Line(name: "23", type: .tram, subtype: .regular),
    Line(name: "24", type: .tram, subtype: .regular),
    Line(name: "31", type: .tram, subtype: .regular),
    Line(name: "32", type: .tram, subtype: .regular),
    Line(name: "33", type: .tram, subtype: .regular),
    Line(name: "C", type: .bus, subtype: .express),
    Line(name: "100", type: .bus, subtype: .regular),
    Line(name: "101", type: .bus, subtype: .regular),
    Line(name: "102", type: .bus, subtype: .regular),
    Line(name: "103", type: .bus, subtype: .regular),
    Line(name: "104", type: .bus, subtype: .regular),
    Line(name: "105", type: .bus, subtype: .regular),
    Line(name: "106", type: .bus, subtype: .regular),
    Line(name: "107", type: .bus, subtype: .regular),
    Line(name: "109", type: .bus, subtype: .regular),
    Line(name: "110", type: .bus, subtype: .regular),
    Line(name: "112", type: .bus, subtype: .regular),
    Line(name: "113", type: .bus, subtype: .regular),
    Line(name: "114", type: .bus, subtype: .regular),
    Line(name: "115", type: .bus, subtype: .regular),
    Line(name: "118", type: .bus, subtype: .regular),
    Line(name: "119", type: .bus, subtype: .regular),
    Line(name: "120", type: .bus, subtype: .regular),
    Line(name: "122", type: .bus, subtype: .regular),
    Line(name: "125", type: .bus, subtype: .regular),
    Line(name: "126", type: .bus, subtype: .regular),
    Line(name: "127", type: .bus, subtype: .regular),
    Line(name: "129", type: .bus, subtype: .regular),
    Line(name: "130", type: .bus, subtype: .regular),
    Line(name: "131", type: .bus, subtype: .regular),
    Line(name: "132", type: .bus, subtype: .regular),
    Line(name: "133", type: .bus, subtype: .regular),
    Line(name: "134", type: .bus, subtype: .regular),
    Line(name: "136", type: .bus, subtype: .regular),
    Line(name: "140", type: .bus, subtype: .regular),
    Line(name: "141", type: .bus, subtype: .regular),
    Line(name: "142", type: .bus, subtype: .regular),
    Line(name: "144", type: .bus, subtype: .regular),
    Line(name: "145", type: .bus, subtype: .regular),
    Line(name: "146", type: .bus, subtype: .regular),
    Line(name: "147", type: .bus, subtype: .regular),
    Line(name: "148", type: .bus, subtype: .regular),
    Line(name: "149", type: .bus, subtype: .regular),
    Line(name: "150", type: .bus, subtype: .regular),
    Line(name: "206", type: .bus, subtype: .night),
    Line(name: "240", type: .bus, subtype: .night),
    Line(name: "241", type: .bus, subtype: .night),
    Line(name: "243", type: .bus, subtype: .night),
    Line(name: "245", type: .bus, subtype: .night),
    Line(name: "246", type: .bus, subtype: .night),
    Line(name: "247", type: .bus, subtype: .night),
    Line(name: "248", type: .bus, subtype: .night),
    Line(name: "249", type: .bus, subtype: .night),
    Line(name: "250", type: .bus, subtype: .night),
    Line(name: "251", type: .bus, subtype: .night),
    Line(name: "253", type: .bus, subtype: .night),
    Line(name: "255", type: .bus, subtype: .night),
    Line(name: "257", type: .bus, subtype: .night),
    Line(name: "259", type: .bus, subtype: .night),
    Line(name: "319", type: .bus, subtype: .regular),
    Line(name: "325", type: .bus, subtype: .regular),
    Line(name: "331", type: .bus, subtype: .regular),
    Line(name: "602", type: .bus, subtype: .suburban),
    Line(name: "607", type: .bus, subtype: .suburban),
    Line(name: "609", type: .bus, subtype: .suburban),
    Line(name: "612", type: .bus, subtype: .suburban),
    Line(name: "116", type: .bus, subtype: .regular),
    Line(name: "128", type: .bus, subtype: .regular)
  ]
}

private func dummyVehicles() -> [Vehicle] {
  let line0 = Line(name:  "1", type: .tram, subtype: .regular)
  let line1 = Line(name:  "4", type: .tram, subtype: .regular)
  let line2 = Line(name: "20", type: .tram, subtype: .regular)
  let line3 = Line(name:  "A", type:  .bus, subtype: .express)
  let line4 = Line(name:  "D", type:  .bus, subtype: .express)

  return [
    Vehicle(id: "0", line: line0, latitude: 51.11, longitude: 17.01, angle: 00.0),
    Vehicle(id: "1", line: line1, latitude: 51.11, longitude: 17.02, angle: 30.0),
    Vehicle(id: "2", line: line2, latitude: 51.11, longitude: 17.03, angle: 60.0),
    Vehicle(id: "3", line: line3, latitude: 51.11, longitude: 17.04, angle: 90.0),
    Vehicle(id: "4", line: line4, latitude: 51.11, longitude: 17.05, angle: 120.0)
  ]
}
