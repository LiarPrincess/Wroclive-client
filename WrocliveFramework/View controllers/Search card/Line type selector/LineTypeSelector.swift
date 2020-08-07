// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias TextStyles = LineTypeSelectorConstants.TextStyles

internal final class LineTypeSelector: UIViewController, LineTypeSelectorViewType {

  // MARK: - Properties

  private let viewModel: LineTypeSelectorViewModel
  private let segmentedControl = UISegmentedControl(frame: .zero)

  // MARK: - Init

  internal init(viewModel: LineTypeSelectorViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.setView(view: self)
  }

  internal required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  internal override func viewDidLoad() {
    super.viewDidLoad()

    self.segmentedControl.setTitleTextAttributes(TextStyles.title.value,
                                                 for: .normal)

    for (index, page) in self.viewModel.pageNames.enumerated() {
      self.segmentedControl.insertSegment(withTitle: page,
                                          at: index,
                                          animated: false)
    }

    self.segmentedControl.addTarget(self,
                                    action: #selector(selectedIndexChanged),
                                    for: .valueChanged)

    self.view.addSubview(self.segmentedControl)
    self.segmentedControl.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  @objc
  private func selectedIndexChanged(_ sender: UISegmentedControl) {
    let index = self.segmentedControl.selectedSegmentIndex
    self.viewModel.viewDidSelect(index: index)
  }

  internal func setPage(index: Int) {
    self.segmentedControl.selectedSegmentIndex = index
  }
}
