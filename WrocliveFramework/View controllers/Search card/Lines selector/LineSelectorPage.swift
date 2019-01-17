// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

private typealias HeaderLayout     = LineSelectorHeaderViewConstants.Layout
private typealias HeaderTextStyles = LineSelectorHeaderViewConstants.TextStyles
private typealias CellLayout       = LineSelectorCellConstants.Layout
private typealias Localization     = Localizable.Search

public final class LineSelectorPage: UIViewController {

  // MARK: - Properties

  private let viewModel: LineSelectorPageViewModel
  private let disposeBag = DisposeBag()

  private lazy var collectionView           = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
  private lazy var collectionViewLayout     = UICollectionViewFlowLayout()
  private lazy var collectionViewDataSource = LineSelectorPage.createDataSource()

  public var scrollView: UIScrollView { return self.collectionView }

  public var contentInset: UIEdgeInsets {
    get { return self.collectionView.contentInset }
    set { self.collectionView.contentInset = newValue }
  }

  public var scrollIndicatorInsets: UIEdgeInsets {
    get { return self.collectionView.scrollIndicatorInsets }
    set { self.collectionView.scrollIndicatorInsets = newValue }
  }

  // MARK: - Init

  public init(_ viewModel: LineSelectorPageViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.initBindings()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bindings

  private func initBindings() {
    self.collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    self.viewModel.sections.asObservable()
      .bind(to: self.collectionView.rx.items(dataSource: self.collectionViewDataSource))
      .disposed(by: disposeBag)

    let setIndicesAgainAfterChangingSections = self.viewModel.sections
      .withLatestFrom(self.viewModel.selectedIndices)

    Driver.merge(setIndicesAgainAfterChangingSections, self.viewModel.selectedIndices)
      .drive(onNext: { [unowned self] in self.selectIndices($0) })
      .disposed(by: disposeBag)

    self.collectionView.rx.itemSelected
      .bind(to: self.viewModel.didSelectIndex)
      .disposed(by: self.disposeBag)

    self.collectionView.rx.itemDeselected
      .bind(to: self.viewModel.didDeselectIndex)
      .disposed(by: self.disposeBag)
  }

  private func selectIndices(_ indicesToSelect: [IndexPath]) {
    let selectedIndices = self.collectionView.indexPathsForSelectedItems ?? []

    // change to sets, so we get ~O(1) lookups
    let selectedIndicesSet = Set(selectedIndices)
    let indicesToSelectSet = Set(indicesToSelect)

    selectedIndices
      .filter  { !indicesToSelectSet.contains($0) }
      .forEach { self.collectionView.deselectItem(at: $0, animated: false) }

    indicesToSelect
      .filter  { !selectedIndicesSet.contains($0) }
      .forEach { self.collectionView.selectItem(at: $0, animated: false, scrollPosition: []) }
  }

  // MARK: - Data source

  private static func createDataSource() -> RxCollectionViewDataSource<LineSelectorSection> {
    return RxCollectionViewDataSource(
      configureCell: { _, collectionView, indexPath, model -> UICollectionViewCell in
        let cell = collectionView.dequeueCell(ofType: LineSelectorCell.self, forIndexPath: indexPath)
        cell.update(from: LineSelectorCellViewModel(model))
        return cell
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath -> UICollectionReusableView in
        switch kind {
        case UICollectionView.elementKindSectionHeader:
          let view = collectionView.dequeueSupplementary(ofType: LineSelectorHeaderView.self, kind: .header, for: indexPath)
          view.update(from: LineSelectorHeaderViewModel(dataSource[indexPath.section]))
          return view
        default:
          fatalError("Unexpected element kind")
        }
      }
    )
  }

  // MARK: - Overriden

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  private func initLayout() {
    self.collectionViewLayout.minimumLineSpacing      = CellLayout.margin
    self.collectionViewLayout.minimumInteritemSpacing = CellLayout.margin

    self.collectionView.registerCell(LineSelectorCell.self)
    self.collectionView.registerSupplementary(LineSelectorHeaderView.self, ofKind: .header)
    self.collectionView.backgroundColor         = Theme.colors.background
    self.collectionView.allowsSelection         = true
    self.collectionView.allowsMultipleSelection = true
    self.collectionView.alwaysBounceVertical    = true

    self.view.addSubview(self.collectionView, constraints: makeEdgesEqualToSuperview())
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.collectionViewLayout.itemSize = self.calculateItemSize()
  }

  private func calculateItemSize() -> CGSize {
    // number of cells:   n
    // number of margins: n-1

    // totalWidth = n * cellWidth + (n-1) * margins
    // solve for n:         n = (totalWidth + margin) / (cellWidth + margin)
    // solve for cellWidth: cellWidth = (totalWidth - (n-1) * margin) / n

    let totalWidth   = self.collectionView.contentWidth
    let margin       = CellLayout.margin
    let minCellWidth = CellLayout.minSize

    let numSectionsThatFit = floor((totalWidth + margin) / (minCellWidth + margin))
    let cellWidth          = (totalWidth - (numSectionsThatFit - 1) * margin) / numSectionsThatFit

    return CGSize(width: cellWidth, height: cellWidth)
  }
}

// MARK: - CollectionViewDelegateFlowLayout

extension LineSelectorPage: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let header = self.collectionViewDataSource[section].model

    let width  = self.collectionView.contentWidth
    let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)

    let text     = NSAttributedString(string: header.lineSubtypeTranslation, attributes: HeaderTextStyles.header)
    let textSize = text.boundingRect(with: bounds, options: .usesLineFragmentOrigin, context: nil)

    let height = textSize.height + HeaderLayout.topInset + HeaderLayout.bottomInset + 1.0
    return CGSize(width: width, height: height)
  }
}
