//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import SnapKit

class BookmarkCell: UITableViewCell {

  //MARK: - Properties

  static let identifier = "BookmarkCell"

  fileprivate let stackView = UIStackView()
  let bookmarkName = UILabel()
  let tramLines = UILabel()
  let busLines = UILabel()

  //MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.initLayout()
    self.initLabelTextObservers()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.deinitLabelTextObservers()
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    let isHandled = self.labelTextObserver(object: object, keyPath: keyPath)
    if !isHandled {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
  }
}

//MARK: - Hide label when its value is empty

extension BookmarkCell {

  fileprivate func initLabelTextObservers() {
    self.bookmarkName.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    self.tramLines.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    self.busLines.addObserver(self, forKeyPath: "text", options: .new, context: nil)
  }

  fileprivate func deinitLabelTextObservers() {
    self.bookmarkName.removeObserver(self, forKeyPath: "text", context: nil)
    self.tramLines.removeObserver(self, forKeyPath: "text", context: nil)
    self.busLines.removeObserver(self, forKeyPath: "text", context: nil)
  }

  fileprivate func labelTextObserver(object: Any?, keyPath: String?) -> Bool {
    if let keyPath = keyPath, let label = object as? UILabel, keyPath == "text" {
      label.isHidden = label.text?.isEmpty ?? true
      return true
    }
    return false
  }
}

//MARK: - UI Init

extension BookmarkCell {

  fileprivate func initLayout() {
    self.stackView.axis = .vertical
    self.stackView.alignment = .fill
    self.stackView.spacing = 5.0
    self.stackView.distribution = .equalSpacing
    self.addSubview(self.stackView)

    self.stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5.0, left: 30.0, bottom: 5.0, right: 30.0))
    }

    applyCommonSettings(self.bookmarkName)
    applyCommonSettings(self.tramLines)
    applyCommonSettings(self.busLines)

    stackView.addArrangedSubview(self.bookmarkName)
    stackView.addArrangedSubview(self.tramLines)
    stackView.addArrangedSubview(self.busLines)
  }

  private func applyCommonSettings(_ label: UILabel) {
    label.numberOfLines = 0
    label.textAlignment = .center
  }

}
