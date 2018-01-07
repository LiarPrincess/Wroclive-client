//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import RxSwift
import Result

typealias ApiResponse<Data> = Observable<Result<Data, ApiError>>

class SearchCardNetworkAdapter {
  static func getAvailableLines() -> ApiResponse<[Line]> {
    return ApiResponse.create { observer -> Disposable in
      Managers.api.getAvailableLines()
        .tap { result in
          switch result {
          case let .fulfilled(lines): observer.onNext(.success(lines))
          case let .rejected(error):  observer.onNext(.failure(toApiError(error)))
          }
          observer.onCompleted()
        }
      return Disposables.create()
    }
  }
}

private func toApiError(_ error: Error) -> ApiError {
  return error as? ApiError ?? ApiError.connectionError
}

//private func refreshAvailableLines(_ selectedLines: [Line]) {
//  self.mode = .loadingData
//
//  firstly { Managers.api.getAvailableLines() }
//    .then { [weak self] lines -> () in
//      guard let strongSelf = self else { return }
//
//      strongSelf.lineSelector.viewModel.inputs.linesChanged.onNext(lines)
//      strongSelf.lineSelector.viewModel.inputs.selectedLinesChanged.onNext(selectedLines)
//
//      strongSelf.mode = .selectingLines
//      strongSelf.updateViewFromLineTypeSelector(animated: false)
//    }
//    .catch { [weak self] error in
//      guard let strongSelf = self else { return }
//
//      let retry = { [weak self] in
//        let delay = AppInfo.Timings.FailedRequestDelay.lines
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
//          self?.refreshAvailableLines(selectedLines)
//        }
//      }
//
//      switch error {
//      case ApiError.noInternet:
//        NetworkAlerts.showNoInternetAlert(in: strongSelf, retry: retry)
//      default:
//        NetworkAlerts.showNetworkingErrorAlert(in: strongSelf, retry: retry)
//      }
//  }
//}
