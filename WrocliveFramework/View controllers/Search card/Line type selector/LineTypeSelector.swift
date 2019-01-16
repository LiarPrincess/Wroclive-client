// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

private typealias TextStyles = LineTypeSelectorConstants.TextStyles

public final class LineTypeSelector: UIViewController {

  // MARK: - Properties

  private let viewModel: LineTypeSelectorViewModel
  private let disposeBag = DisposeBag()

  private let segmentedControl = UISegmentedControl(frame: .zero)

  // MARK: - Init

  public init(_ viewModel: LineTypeSelectorViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    self.segmentedControl.setTitleTextAttributes(TextStyles.title.value, for: .normal)
    for (index, page) in self.viewModel.pages.enumerated() {
      self.segmentedControl.insertSegment(withTitle: page, at: index, animated: false)
    }

    self.segmentedControl.rx.selectedSegmentIndex
      .bind(to: self.viewModel.didSelectIndex)
      .disposed(by: self.disposeBag)

    self.viewModel.selectedIndex
      .drive(self.segmentedControl.rx.selectedSegmentIndex)
      .disposed(by: self.disposeBag)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.segmentedControl, constraints: makeEdgesEqualToSuperview())
  }
}
