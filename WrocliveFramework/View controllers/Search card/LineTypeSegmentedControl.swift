// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private typealias Localization = Localizable.Search

internal final class LineTypeSegmentedControl: UIView {

  internal enum Constants {

    /// Proposed height
    internal static let nominalHeight = CGFloat(30.0)

    internal static let titleAttributes = TextAttributes(style: .body, color: .tint)
  }

  internal typealias PageType = SearchCardState.Page

  private let pages = [PageType.tram, PageType.bus]
  private let segmentedControl = UISegmentedControl(frame: .zero)

  // MARK: - Init

  private let onValueChanged: (PageType) -> Void

  internal init(onValueChanged: @escaping (PageType) -> Void) {
    self.onValueChanged = onValueChanged
    super.init(frame: .zero)

    let titleAttributes = Constants.titleAttributes.value
    self.segmentedControl.setTitleTextAttributes(titleAttributes, for: .normal)

    for (index, page) in self.pages.enumerated() {
      let title = Self.toPageName(page)
      self.segmentedControl.insertSegment(withTitle: title,
                                          at: index,
                                          animated: false)
    }

    self.segmentedControl.addTarget(self,
                                    action: #selector(self.selectedIndexChanged),
                                    for: .valueChanged)

    self.addSubview(self.segmentedControl)
    self.segmentedControl.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  private static func toPageName(_ type: PageType) -> String {
    switch type {
    case .tram: return Localization.Pages.tram
    case .bus: return Localization.Pages.bus
    }
  }

  // swiftlint:disable:next unavailable_function
  internal required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  @objc
  private func selectedIndexChanged(_ sender: UISegmentedControl) {
    let index = self.segmentedControl.selectedSegmentIndex
    let page = self.pages[index]
    self.onValueChanged(page)
  }

  internal func setPage(page: PageType) {
    guard let index = self.pages.firstIndex(where: { $0 == page }) else {
      fatalError("LineTypeSegmentedControl does not support '\(page)'")
    }

    self.segmentedControl.selectedSegmentIndex = index
  }
}
