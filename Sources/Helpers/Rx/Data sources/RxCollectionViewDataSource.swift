//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxCollectionViewDataSource<TSectionType: RxSectionType>
  : NSObject, UICollectionViewDataSource, RxCollectionViewDataSourceType {

  // MARK: - Properties

  typealias TSection = TSectionType.Model
  typealias TItem    = TSectionType.Item

  typealias ConfigureCell              = (RxCollectionViewDataSource<TSectionType>, UICollectionView, IndexPath, TItem)  -> UICollectionViewCell
  typealias ConfigureSupplementaryView = (RxCollectionViewDataSource<TSectionType>, UICollectionView, String, IndexPath) -> UICollectionReusableView

  var configureCell: ConfigureCell {
    didSet {
      #if DEBUG
        ensureNotMutatedAfterBinding()
      #endif
    }
  }

  var configureSupplementaryView: ConfigureSupplementaryView? {
    didSet {
      #if DEBUG
        ensureNotMutatedAfterBinding()
      #endif
    }
  }

  // MARK: - Init

  public init(
    configureCell:              @escaping ConfigureCell,
    configureSupplementaryView: ConfigureSupplementaryView? = nil) {
    self.configureCell              = configureCell
    self.configureSupplementaryView = configureSupplementaryView
  }

  // MARK: - Items

  // This structure exists because model can be mutable
  // In that case current state value should be preserved.
  // The state that needs to be preserved is ordering of items in section
  // and their relationship with section.
  // If particular item is mutable, that is irrelevant for this logic to function
  // properly.
  private typealias SectionModelSnapshot = RxSectionModel<TSection, TItem>

  private var _sectionModels: [SectionModelSnapshot] = []

  subscript(section: Int) -> RxSectionModel<TSection, TItem> {
    return self._sectionModels[section]
  }

  subscript(indexPath: IndexPath) -> TItem {
    return self._sectionModels[indexPath.section].items[indexPath.item]
  }

  // MARK: - RxCollectionViewDataSourceType

  typealias Element = [TSectionType]

  func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
    Binder(self) { dataSource, elements in
      #if DEBUG
        self._dataSourceBound = true
      #endif

      let models = elements.map { SectionModelSnapshot(model: $0.model, items: $0.items) }
      if models != dataSource._sectionModels {
        dataSource._sectionModels = models
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
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

  // MARK: - UICollectionViewDataSource

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return _sectionModels.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard section < _sectionModels.count else { return 0 }
    return _sectionModels[section].items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    precondition(indexPath.item < _sectionModels[indexPath.section].items.count)
    return configureCell(self, collectionView, indexPath, self._sectionModels[indexPath])
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return configureSupplementaryView!(self, collectionView, kind, indexPath)
  }

  // swiftlint:disable:next implicitly_unwrapped_optional
  override func responds(to aSelector: Selector!) -> Bool {
    if aSelector == #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:)) {
      return configureSupplementaryView != nil
    }
    else {
      return super.responds(to: aSelector)
    }
  }
}
