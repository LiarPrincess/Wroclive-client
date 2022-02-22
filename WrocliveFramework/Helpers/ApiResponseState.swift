// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

/// React to new response from api.
///
/// Basically a link between stateless `Redux` and statefull `UI`.
public final class ApiResponseState<Data: Equatable> {

  private var old: AppState.ApiResponseState<Data>?
  private var finalState: Data?

  // MARK: - Mark as final

  /// Mark state as final so that it will ignore any new updates.
  public func markAsFinal(state: Data) {
    self.finalState = state
    // Release memory
    self.old = nil
  }

  // MARK: - Update

  public enum UpdateResult {
    /// We already reached our final state.
    case final(Data)

    /// We just started, and got `Data` in the 1st update.
    case initialData(Data)
    /// We just got a new data.
    case newData(Data)
    /// The same data as before.
    case sameDataAsBefore(Data)

    /// We just started, and got `ApiError` in the 1st update.
    case initialError(ApiError)
    /// We just got a new error.
    case newError(ApiError)
    /// The same error as before.
    case sameErrorAsBefore(ApiError)

    case initialInProgres
    case inProgres(PreviousResponse)

    case initialNone
    case none(PreviousResponse)
  }

  public enum PreviousResponse {
    case none
    case inProgress
    case data
    case error

    fileprivate init(old: AppState.ApiResponseState<Data>) {
      switch old {
      case .none: self = .none
      case .inProgress: self = .inProgress
      case .data: self = .data
      case .error: self = .error
      }
    }
  }

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  public func update(from response: AppState.ApiResponseState<Data>) -> UpdateResult {
    if let state = self.finalState {
      return .final(state)
    }

    defer { self.old = response }

    switch response {
    case .data(let data):
      guard let old = self.old else {
        return .initialData(data)
      }

      switch old {
      case .data(let oldData):
        let isStale = data == oldData
        return isStale ? .sameDataAsBefore(data) : .newData(data)
      case .error,
           .inProgress,
           .none:
        return .newData(data)
      }

    case .error(let error):
      guard let old = self.old else {
        return .initialError(error)
      }

      switch old {
      case .error(let oldError):
        let haveEqualType = self.haveEqualType(error, oldError)
        return haveEqualType ? .sameErrorAsBefore(error) : .newError(error)
      case .data,
           .inProgress,
           .none:
        return .newError(error)
      }

    case .inProgress:
      switch self.old {
      case .some(let old):
        let previous = PreviousResponse(old: old)
        return .inProgres(previous)
      case nil:
        return .initialInProgres
      }

    case .none:
      switch self.old {
      case .some(let old):
        let previous = PreviousResponse(old: old)
        return .none(previous)
      case nil:
        return .initialNone
      }
    }
  }

  private func haveEqualType(_ lhs: ApiError, _ rhs: ApiError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidResponse, .invalidResponse),
         (.reachabilityError, .reachabilityError),
         (.otherError, .otherError):
      return true
    default:
      return false
    }
  }
}
