// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable vertical_whitespace


import WrocliveFramework

extension ReduxTestCase {

  // MARK: ApiAction

  func isApiUpdateLinesAction(at index: Int) -> Bool {
    guard index < self.dispatchedActions.count else { return false }
    switch self.dispatchedActions[index] {
    case ApiAction.updateLines: return true
    default: return false
    }
  }

  func isApiUpdateVehicleLocationsAction(at index: Int) -> Bool {
    guard index < self.dispatchedActions.count else { return false }
    switch self.dispatchedActions[index] {
    case ApiAction.updateVehicleLocations: return true
    default: return false
    }
  }

  // MARK: ApiResponseAction

  func getApiResponseSetLinesAction(at index: Int) -> ApiResponseState<[Line]>? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let ApiResponseAction.setLines(value): return value
    default: return nil
    }
  }

  func getApiResponseSetVehicleLocationsAction(at index: Int) -> ApiResponseState<[Vehicle]>? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let ApiResponseAction.setVehicleLocations(value): return value
    default: return nil
    }
  }

  // MARK: BookmarksAction

  func getBookmarksAddAction(at index: Int) -> (String, [Line])? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let BookmarksAction.add(value0, value1): return (value0, value1)
    default: return nil
    }
  }

  func getBookmarksRemoveAction(at index: Int) -> Int? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let BookmarksAction.remove(value): return value
    default: return nil
    }
  }

  func getBookmarksMoveAction(at index: Int) -> (Int, Int)? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let BookmarksAction.move(value0, value1): return (value0, value1)
    default: return nil
    }
  }

  // MARK: SearchCardStateAction

  func getSearchCardStateSelectPageAction(at index: Int) -> LineType? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let SearchCardStateAction.selectPage(value): return value
    default: return nil
    }
  }

  func getSearchCardStateSelectLineAction(at index: Int) -> Line? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let SearchCardStateAction.selectLine(value): return value
    default: return nil
    }
  }

  func getSearchCardStateDeselectLineAction(at index: Int) -> Line? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let SearchCardStateAction.deselectLine(value): return value
    default: return nil
    }
  }

  // MARK: TrackedLinesAction

  func getTrackedLinesStartTrackingAction(at index: Int) -> [Line]? {
    guard index < self.dispatchedActions.count else { return nil }
    switch self.dispatchedActions[index] {
    case let TrackedLinesAction.startTracking(value): return value
    default: return nil
    }
  }

}
