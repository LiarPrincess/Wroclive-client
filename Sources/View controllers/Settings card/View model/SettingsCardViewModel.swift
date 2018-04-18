//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias SettingsSection = RxSectionModel<SettingsSectionType, SettingsCellType>

protocol SettingsCardViewModelType {
  var inputs:  SettingsCardViewModelInput  { get }
  var outputs: SettingsCardViewModelOutput { get }
}

class SettingsCardViewModel: SettingsCardViewModelType, SettingsCardViewModelInput, SettingsCardViewModelOutput {

  // MARK: - Properties

  private let _itemSelected = PublishSubject<IndexPath>()

  // MARK: - Input

  lazy var itemSelected: AnyObserver<IndexPath> = self._itemSelected.asObserver()

  // MARK: - Output

  lazy var items: Driver<[SettingsSection]> = {
    let generalSection = SettingsSection(model: .general, items: [.share, .rate, .about])

    return Observable.just([generalSection])
      .asDriver(onErrorJustReturn: [])
  }()

  lazy var selectedCell = self._itemSelected.withLatestFrom(self.items) { $1[$0] }.share()

  lazy var showShareControl: Driver<Void> = self.selectedCell.filter(.share).asDriver(onErrorDriveWith: .never())
  lazy var showRateControl:  Driver<Void> = self.selectedCell.filter(.rate) .asDriver(onErrorDriveWith: .never())
  lazy var showAboutPage:    Driver<Void> = self.selectedCell.filter(.about).asDriver(onErrorDriveWith: .never())

  // MARK: - Input/Output

  var inputs:  SettingsCardViewModelInput  { return self }
  var outputs: SettingsCardViewModelOutput { return self }
}

// MARK: - Helpers

private extension Observable where E == SettingsCellType {
  func filter(_ cell: SettingsCellType) -> Observable<Void> {
    return self.filter { $0 == cell }.map { _ in () }
  }
}
