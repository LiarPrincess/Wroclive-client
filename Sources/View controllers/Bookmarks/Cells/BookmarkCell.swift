//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Layout = BookmarksViewControllerConstants.Layout.Cell

class BookmarkCell: UITableViewCell {

  //MARK: - Properties

  var lineViewModels = [[BookmarkCellLineViewModel]]()

  //MARK: Layout

  let bookmarkName = UILabel()

  let collectionViewLayout = UICollectionViewFlowLayout()

  lazy var collectionView: BookmarkCellLineCollectionView = {
    return BookmarkCellLineCollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
  }()

  //MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Overriden

  // disable alpha, so we dont end up with transparent cells when reordering
  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  //MARK: - Methods

  func setUp(with viewModel: BookmarkCellViewModel) {
    self.bookmarkName.text = viewModel.bookmarkName
    self.lineViewModels    = viewModel.lineViewModels
    self.collectionView.reloadData()

    self.collectionView.invalidateIntrinsicContentSize()
    self.invalidateIntrinsicContentSize()
  }

}

//MARK: - UI Init

extension BookmarkCell {

  func initLayout() {
    self.bookmarkName.numberOfLines = 0
    self.bookmarkName.textAlignment = .center
    self.bookmarkName.font          = FontManager.instance.bookmarkCellTitle
    self.addSubview(self.bookmarkName)

    self.bookmarkName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.collectionView.register(BookmarkCellLine.self)
    self.collectionView.backgroundColor          = UIColor.white
    self.collectionView.allowsSelection          = false
    self.collectionView.allowsMultipleSelection  = false
    self.collectionView.isUserInteractionEnabled = false

    self.collectionView.dataSource = self
    self.collectionView.delegate   = self

    self.addSubview(self.collectionView)

    self.collectionView.snp.makeConstraints { make in
      make.top.equalTo(self.bookmarkName.snp.bottom)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
      make.bottom.equalToSuperview()
    }
  }

}

//MARK: - UICollectionViewDataSource

extension BookmarkCell: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.lineViewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.lineViewModels[section].count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell      = collectionView.dequeueReusableCell(ofType: BookmarkCellLine.self, forIndexPath: indexPath)
    let viewModel = self.lineViewModels[indexPath.section][indexPath.row]

    cell.setUp(with: viewModel)
    return cell
  }
  
}

//MARK: - CollectionViewDelegateFlowLayout

extension BookmarkCell: UICollectionViewDelegateFlowLayout {

  //MARK: - Size

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let font = FontManager.instance.bookmarkCellContent!
    let fontAttribute = [NSFontAttributeName: font]

    let lineViewModel = self.lineViewModels[indexPath.section][indexPath.row]
    let size = (lineViewModel.lineName as NSString).size(attributes: fontAttribute)

    return CGSize(width: size.width + 10.0, height: size.height + 2.0)
  }

  //MARK: - Margin

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Layout.LineCell.minMargin
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Layout.LineCell.minMargin
  }

  //MARK: - Content placement

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return Layout.LineSection.insets
  }

}
