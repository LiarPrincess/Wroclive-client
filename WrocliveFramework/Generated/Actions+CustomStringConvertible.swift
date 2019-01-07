// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable vertical_whitespace

// DO NOT PRINT/LOG USER DATA!
// IT IS A MESS THAT WE DON'T WANT TO GET INTO!

extension ApiAction: CustomStringConvertible {
  public var description: String {
    switch self {
    case .updateLines: return "ApiAction.updateLines"
    case .updateVehicleLocations: return "ApiAction.updateVehicleLocations"
    }
  }
}

extension ApiResponseAction: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .setLines(response): return "ApiResponseAction.setLines(\(describe(response)))"
    case let .setVehicleLocations(response): return "ApiResponseAction.setVehicleLocations(\(describe(response)))"
    }
  }
}

extension BookmarksAction: CustomStringConvertible {
  public var description: String {
    switch self {
    case .add: return "BookmarksAction.add"
    case .remove: return "BookmarksAction.remove"
    case .move: return "BookmarksAction.move"
    }
  }
}

extension SearchCardStateAction: CustomStringConvertible {
  public var description: String {
    switch self {
    case .selectPage: return "SearchCardStateAction.selectPage"
    case .selectLine: return "SearchCardStateAction.selectLine"
    case .deselectLine: return "SearchCardStateAction.deselectLine"
    }
  }
}

extension TrackedLinesAction: CustomStringConvertible {
  public var description: String {
    switch self {
    case .startTracking: return "TrackedLinesAction.startTracking"
    }
  }
}


private func describe<Data>(_ resonse: ApiResponseState<Data>) -> String {
  switch resonse {
  case .none:       return ".none"
  case .inProgress: return ".inProgress"
  case .data:       return ".data"
  case let .error(error): return ".error(\(String(describing: error)))"
  }
}
