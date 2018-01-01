//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import RxSwift
import PromiseKit

class SearchCardNetworkAdapter {

  static func getAvailableLines() -> Observable<[Line]> {
    return .create { (observer: AnyObserver<[Line]>) -> Disposable in
      Managers.api.getAvailableLines()
        .then { (lines: [Line]) -> [Line] in
          observer.onNext(lines)
          observer.onCompleted()
          return lines
        }
        .catch { observer.onError($0) }

      return Disposables.create()
    }
  }
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
