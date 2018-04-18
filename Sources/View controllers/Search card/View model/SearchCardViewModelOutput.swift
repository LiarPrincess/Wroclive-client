//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Result
import RxSwift
import RxCocoa

protocol SearchCardViewModelOutput {

  /**
   - input.pageSelected
   - input.pageDidTransition
   default: from manager
   */
  var page: Driver<LineType> { get }

  /**
   - from manager -> values
   */
  var lines: Driver<[Line]> { get }

  /**
   - input.lineSelected
   - input.lineDeselected
   default: from manager
   */
  var selectedLines: Driver<[Line]> { get }

  /**
   - any self.lines
   */
  var isLineSelectorVisible: Driver<Bool> { get }

  /**
   - not self.isLineSelectorVisible
   */
  var isPlaceholderVisible: Driver<Bool> { get }

  /**
   - from manager -> error
   */
  var showApiErrorAlert: Driver<ApiError> { get }

  /**
   - input.bookmarkButtonPressed -> any self.selectedLines -> nameInput
   - input.bookmarkButtonPressed -> opposite               -> noLinesSelected
   */
  var showBookmarkAlert: Driver<SearchCardBookmarkAlert> { get }

  /**
   - input.searchButtonPressed
   */
  var shouldClose: Driver<Void> { get }
}
