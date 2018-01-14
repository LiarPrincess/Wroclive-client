//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LineSelectorPageViewModelInput {
  var linesChanged:         AnyObserver<[Line]> { get }
  var selectedLinesChanged: AnyObserver<[Line]> { get }
}

protocol LineSelectorPageViewModelOutput {
  var sections:      Driver<[LineSelectionSection]> { get }
  var selectedLines: Driver<[Line]>                 { get }
}

class LineSelectorPageViewModel: LineSelectorPageViewModelInput, LineSelectorPageViewModelOutput {

  // MARK: - Properties

  private let _linesChanged         = PublishSubject<[Line]>()
  private let _selectedLinesChanged = PublishSubject<[Line]>()

  // MARK: - Input

  lazy var linesChanged:         AnyObserver<[Line]> = self._linesChanged.asObserver()
  lazy var selectedLinesChanged: AnyObserver<[Line]> = self._selectedLinesChanged.asObserver()

  // MARK: - Output

  lazy var sections: Driver<[LineSelectionSection]> = self._linesChanged
    .map { LineSelectionSectionCreator.create($0) }
    .asDriver(onErrorJustReturn: [])

  lazy var selectedLines: Driver<[Line]> = self._selectedLinesChanged
    .asDriver(onErrorJustReturn: [])

  // MARK: - Input/Output

  var inputs:  LineSelectorPageViewModelInput  { return self }
  var outputs: LineSelectorPageViewModelOutput { return self }
}
