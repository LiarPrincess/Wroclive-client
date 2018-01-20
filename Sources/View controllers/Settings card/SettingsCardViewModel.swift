//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias SettingsSection = RxSectionModel<SettingsSectionType, SettingsCellType>

protocol SettingsCardViewModelInput {
  var itemSelected: AnyObserver<IndexPath> { get }
}

protocol SettingsCardViewModelOutput {
  var items: Driver<[SettingsSection]> { get }

  var shouldClose: Driver<Void> { get }
}

class SettingsCardViewModel: SettingsCardViewModelInput, SettingsCardViewModelOutput {

  // MARK: - Properties

  private let _itemSelected = PublishSubject<IndexPath>()

  // MARK: - Input

  lazy var itemSelected: AnyObserver<IndexPath> = self._itemSelected.asObserver()

  // MARK: - Output

  lazy var items: Driver<[SettingsSection]> = {
    let mapTypeSection = SettingsSection(model: .mapType, items: [.mapType])
    let generalSection = SettingsSection(model: .general, items: [.share, .rate, .about])

    return Observable.just([mapTypeSection, generalSection])
      .asDriver(onErrorJustReturn: [])
  }()

  lazy var shouldClose: Driver<Void> = Observable.never().asDriver(onErrorDriveWith: .never())

  // MARK: - Input/Output

  var inputs:  SettingsCardViewModelInput  { return self }
  var outputs: SettingsCardViewModelOutput { return self }
}
