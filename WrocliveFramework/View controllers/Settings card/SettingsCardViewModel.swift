// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift

public protocol SettingsCardViewModelDelegate: AnyObject {
  func rateApp()
  func showPrivacyPolicy()
  func showShareActivity()
  func reportError()
  func showCode()
}

public protocol SettingsCardViewType: AnyObject {
  func setMapType(mapType: MapType)
}

public final class SettingsCardViewModel: StoreSubscriber {

  // MARK: - Properties

  public let sections = [
    SettingsSection.mapType,
    SettingsSection.general([
      .share,
      .rate,
      .privacyPolicy
    ]),
    SettingsSection.programming([
      .reportError,
      .showCode
    ])
  ]

  private let store: Store<AppState>
  private weak var view: SettingsCardViewType?
  private weak var delegate: SettingsCardViewModelDelegate?

  // MARK: - Init

  public init(store: Store<AppState>, delegate: SettingsCardViewModelDelegate) {
    self.store = store
    self.delegate = delegate
  }

  // MARK: - View

  public func setView(view: SettingsCardViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.store.subscribe(self)
  }

  // MARK: - View inputs

  public func viewDidSelectMapType(mapType: MapType) {
    let action = MapTypeAction.set(mapType)
    self.store.dispatch(action)
  }

  // swiftlint:disable:next cyclomatic_complexity
  public func viewDidSelectRow(at index: IndexPath) {
    guard let section = self.getSection(at: index.section) else {
      return
    }

    switch section {
    case .mapType:
      break

    case .general(let cells):
      guard cells.indices.contains(index.row) else {
        return
      }

      switch cells[index.row] {
      case .share: self.delegate?.showShareActivity()
      case .rate: self.delegate?.rateApp()
      case .privacyPolicy: self.delegate?.showPrivacyPolicy()
      }

    case .programming(let cells):
      guard cells.indices.contains(index.row) else {
        return
      }

      switch cells[index.row] {
      case .reportError: self.delegate?.reportError()
      case .showCode: self.delegate?.showCode()
      }
    }
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    let mapType = state.mapType
    self.view?.setMapType(mapType: mapType)
  }

  // MARK: - Get

  public func getSection(at index: Int) -> SettingsSection? {
    guard self.sections.indices.contains(index) else {
      return nil
    }

    return self.sections[index]
  }
}
