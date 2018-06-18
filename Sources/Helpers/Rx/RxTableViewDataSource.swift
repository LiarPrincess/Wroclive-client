//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Copy of: https://github.com/RxSwiftCommunity/RxDataSources
// Simplified for performance, not exactly Rx-correct
class RxTableViewDataSource<SectionType: RxSectionType>
  : NSObject, UITableViewDataSource, RxTableViewDataSourceType {

  // MARK: - Properties

  typealias Section = SectionType.Model
  typealias Item    = SectionType.Item

  typealias ConfigureCell         = (RxTableViewDataSource<SectionType>, UITableView, IndexPath, Item) -> UITableViewCell
  typealias CanEditRowAtIndexPath = (RxTableViewDataSource<SectionType>, IndexPath) -> Bool
  typealias CanMoveRowAtIndexPath = (RxTableViewDataSource<SectionType>, IndexPath) -> Bool

  var configureCell: ConfigureCell {
    didSet {
      #if DEBUG
        ensureNotMutatedAfterBinding()
      #endif
    }
  }

  var canEditRowAtIndexPath: CanEditRowAtIndexPath {
    didSet {
      #if DEBUG
        ensureNotMutatedAfterBinding()
      #endif
    }
  }
  var canMoveRowAtIndexPath: CanMoveRowAtIndexPath {
    didSet {
      #if DEBUG
        ensureNotMutatedAfterBinding()
      #endif
    }
  }

  // MARK: - Init

  public init(
    configureCell:           @escaping ConfigureCell,
    canEditRowAtIndexPath:   @escaping CanEditRowAtIndexPath   = { _, _ in false },
    canMoveRowAtIndexPath:   @escaping CanMoveRowAtIndexPath   = { _, _ in false }) {
    self.configureCell           = configureCell
    self.canEditRowAtIndexPath   = canEditRowAtIndexPath
    self.canMoveRowAtIndexPath   = canMoveRowAtIndexPath
  }

  // MARK: - Items

  // This structure exists because model can be mutable
  // In that case current state value should be preserved.
  // The state that needs to be preserved is ordering of items in section
  // and their relationship with section.
  // If particular item is mutable, that is irrelevant for this logic to function
  // properly.
  private typealias SectionModelSnapshot = RxSectionModel<Section, Item>

  private var _sectionModels: [SectionModelSnapshot] = []

  subscript(section: Int) -> RxSectionModel<Section, Item> {
    return self._sectionModels[section]
  }

  subscript(indexPath: IndexPath) -> Item {
    return self._sectionModels[indexPath.section].items[indexPath.item]
  }

  // MARK: - RxTableViewDataSourceType

  typealias Element = [SectionType]

  func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
    Binder(self) { dataSource, elements in
      #if DEBUG
        self._dataSourceBound = true
      #endif

      let models = elements.map { SectionModelSnapshot(model: $0.model, items: $0.items) }
      if models != dataSource._sectionModels {
        dataSource._sectionModels = models
        tableView.reloadData()
      }
    }.on(observedEvent)
  }

  #if DEBUG
  // If data source has already been bound, then mutating it
  // afterwards isn't something desired.
  // This simulates immutability after binding
  private var _dataSourceBound: Bool = false

  private func ensureNotMutatedAfterBinding() {
    // swiftlint:disable:next line_length
    assert(!_dataSourceBound, "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.")
  }

  #endif

  // MARK: - UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    return self._sectionModels.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard section < _sectionModels.count else { return 0 }
    return _sectionModels[section].items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    precondition(indexPath.item < self._sectionModels[indexPath.section].items.count)
    return configureCell(self, tableView, indexPath, self._sectionModels[indexPath])
  }

  // MARK: - Moving/reordering

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return self.canMoveRowAtIndexPath(self, indexPath)
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    self._sectionModels.move(from: sourceIndexPath, to: destinationIndexPath)
  }

  // MARK: - Editing

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return self.canEditRowAtIndexPath(self, indexPath)
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      self._sectionModels.remove(at: indexPath)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    case .none, .insert: break
    }
  }
}
