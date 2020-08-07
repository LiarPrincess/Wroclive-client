// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private typealias Layout = SearchCardConstants.Layout
private typealias TextStyles = LineTypeSegmentedControlConstants.TextStyles
private typealias Localization = Localizable.Search

internal final class LineTypeSegmentedControl: UIView {

  private let pages = [LineType.tram, LineType.bus]
  private let segmentedControl = UISegmentedControl(frame: .zero)

  private let onPageSelected: (LineType) -> ()

  internal init(onPageSelected: @escaping (LineType) -> ()) {
    self.onPageSelected = onPageSelected
    super.init(frame: .zero)

    let titleAttributes = TextStyles.title.value
    self.segmentedControl.setTitleTextAttributes(titleAttributes, for: .normal)

    for (index, page) in self.pages.enumerated() {
      let title = Self.toPageName(page)
      self.segmentedControl.insertSegment(withTitle: title,
                                          at: index,
                                          animated: false)
    }

    self.segmentedControl.addTarget(self,
                                    action: #selector(selectedIndexChanged),
                                    for: .valueChanged)

    self.addSubview(self.segmentedControl)
    self.segmentedControl.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  private static func toPageName(_ lineType: LineType) -> String {
    switch lineType {
    case .tram: return Localization.Pages.tram
    case .bus:  return Localization.Pages.bus
    }
  }

  internal required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc
  private func selectedIndexChanged(_ sender: UISegmentedControl) {
    let index = self.segmentedControl.selectedSegmentIndex
    let page = self.pages[index]
    self.onPageSelected(page)
  }

  internal func setPage(page: LineType) {
    if let index = self.pages.firstIndex(of: page) {
      self.segmentedControl.selectedSegmentIndex = index
    }
  }
}
