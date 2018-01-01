//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

//private func loadSavedState() {
//  let state = Managers.search.getSavedState()
//  self.lineTypeSelector.rawValue = state.selectedLineType
//  self.refreshAvailableLines(state.selectedLines)
//}
//
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
//
//private func saveState() {
//  // if we have not downloaded lines then avoid override of state
//  //    guard self.mode == .selectingLines else { return }
//  //
//  //    let lineType = self.lineTypeSelector.rawValue
//  //    let lines    = self.linesSelector.selectedLines
//  //
//  //    let state = SearchState(withSelected: lineType, lines: lines)
//  //    Managers.search.saveState(state)
//}
