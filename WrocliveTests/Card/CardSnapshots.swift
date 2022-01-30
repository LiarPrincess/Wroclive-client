// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import SnapshotTesting
@testable import WrocliveFramework

// swiftlint:disable trailing_closure
// swiftformat:disable numberFormatting

private typealias Constants = CardContainer.Constants

class CardSnapshots: XCTestCase, SnapshotTestCase {

  func test_empty() {
    self.onAllDevices { assertSnapshot in
      let card = CardContainer(onViewDidDisappear: {})
      assertSnapshot(card, .errorOnThisLine())
    }
  }

  func test_withContent() {
    self.onAllDevices { assertSnapshot in
      let card = CardContainer(onViewDidDisappear: {})

      let content = Content()
      card.setContent(content)

      assertSnapshot(card, .errorOnThisLine())
    }
  }

  func test_dark() {
    self.inDarkMode { assertSnapshot in
      let card = CardContainer(onViewDidDisappear: {})
      assertSnapshot(card, .errorOnThisLine())
    }
  }
}

private class Content: UIViewController, CardPresentable {

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let header = self.createHeader(title: "Title")
    self.view.addSubview(header)
    header.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    let content = self.createContent()
    self.view.insertSubview(content, belowSubview: header)
    content.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func createHeader(title: String) -> UIView {
    let header = ExtraLightVisualEffectView()
    header.contentView.addBottomBorder()
    header.setContentHuggingPriority(900, for: .vertical)

    let titleLabel = UILabel()
    let titleAttributes = TextAttributes(style: .largeTitle)
    titleLabel.attributedText = NSAttributedString(string: title,
                                                   attributes: titleAttributes)

    header.contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.recommendedContentTopOffset + 8.0)
      make.bottom.equalToSuperview().offset(CGFloat(-8.0))
      make.left.equalToSuperview().offset(CGFloat(16.0))
      make.right.equalToSuperview().offset(CGFloat(-16.0))
    }

    return header
  }

  private func createContent() -> UIView {
    // https://www.colourlovers.com/palette/4762348/Just_To_Get_Home
    let colors: [UInt64] = [
      0x78BEDA,
      0x899EC5,
      0x9582B5,
      0x475D8A,
      0x3A3970
    ]

    let result = UIView()
    var previousView: UIView?

    for hex in colors {
      let view = UIView()
      view.backgroundColor = UIColor(hex: hex)
      defer { previousView = view }

      result.addSubview(view)
      view.snp.makeConstraints { make in
        make.top.bottom.equalToSuperview()

        if let previous = previousView {
          make.left.equalTo(previous.snp.right)
          make.width.equalTo(previous.snp.width)
        } else {
          make.left.equalToSuperview()
        }
      }
    }

    // swiftlint:disable:next force_unwrapping
    let lastView = previousView!
    lastView.snp.makeConstraints { make in
      make.right.equalToSuperview()
    }

    return result
  }
}

extension UIColor {
  convenience init(hex: UInt64) {
    let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
    let green = CGFloat((hex & 0xff00) >> 8) / 255.0
    let blue = CGFloat((hex & 0xff) >> 0) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: CGFloat(1.0))
  }
}
