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

class LineSelectorPage: UIViewController {

  // MARK: - Properties

  private let sections   = PublishSubject<[LineSelectorSection]>()
  private let disposeBag = DisposeBag()

  lazy var lineSelected = self.collectionView.rx.itemSelected
    .flatMap { [weak self] in Observable.from(optional: self?.collectionViewDataSource[$0]) }

  lazy var lineDeselected = self.collectionView.rx.itemDeselected
    .flatMap { [weak self] in Observable.from(optional: self?.collectionViewDataSource[$0]) }

  private lazy var collectionView           = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
  private lazy var collectionViewLayout     = UICollectionViewFlowLayout()
  private lazy var collectionViewDataSource = LineSelectorPage.createDataSource()

  var scrollView: UIScrollView { return self.collectionView }

  var contentInset: UIEdgeInsets {
    get { return self.collectionView.contentInset }
    set { self.collectionView.contentInset = newValue }
  }

  var scrollIndicatorInsets: UIEdgeInsets {
    get { return self.collectionView.scrollIndicatorInsets }
    set { self.collectionView.scrollIndicatorInsets = newValue }
  }

  // MARK: - Init

  init() {
    super.init(nibName: nil, bundle: nil)
    self.initBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initBindings() {
    self.collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    self.sections.asObservable()
      .bind(to: self.collectionView.rx.items(dataSource: self.collectionViewDataSource))
      .disposed(by: disposeBag)
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
        case UICollectionElementKindSectionHeader:
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

  override func viewDidLoad() {
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

  override func viewDidLayoutSubviews() {
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

  // MARK: - Setters

  func setLines(_ lines: [Line], selected selectedLines: [Line]) {
    let sections = LineSelectorSectionCreator.create(lines)
    self.sections.onNext(sections)

    let selectedIndices = self.collectionView.indexPathsForSelectedItems ?? []

    for (sectionIndex, section) in sections.enumerated() {
      for (lineIndex, line) in section.items.enumerated() {
        let indexPath = IndexPath(row: lineIndex, section: sectionIndex)

        let isSelected   = selectedIndices.contains(indexPath)
        let shouldSelect = selectedLines.contains(line)

        if isSelected != shouldSelect {
          if shouldSelect { self.collectionView.selectItem  (at: indexPath, animated: false, scrollPosition: []) }
          else            { self.collectionView.deselectItem(at: indexPath, animated: false) }
        }
      }
    } /* for end */
  }
}

// MARK: - CollectionViewDelegateFlowLayout

extension LineSelectorPage: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let header = self.collectionViewDataSource[section].model

    let width  = self.collectionView.contentWidth
    let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)

    let text     = NSAttributedString(string: header.lineSubtypeTranslation, attributes: HeaderTextStyles.header)
    let textSize = text.boundingRect(with: bounds, options: .usesLineFragmentOrigin, context: nil)

    let height = textSize.height + HeaderLayout.topInset + HeaderLayout.bottomInset + 1.0
    return CGSize(width: width, height: height)
  }
}
