//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LineSelectionViewController: UIPageViewController {

  // MARK: - Properties

  let viewModel = LineSelectionViewModel()
  private let disposeBag = DisposeBag()

  private let tramPage = LineSelectionPage()
  private let busPage  = LineSelectionPage()
  private lazy var pages = [self.tramPage, self.busPage]

  var currentPage: LineType {
    get {
      // note that one of the pages is ALWAYS selected
      let page = self.viewControllers?.first as? LineSelectionPage
      return page == self.tramPage ? .tram : .bus
    }
    set { self.setCurrentPage(newValue, animated: false) }
  }

  var contentInset: UIEdgeInsets {
    get { return self.tramPage.contentInset }
    set { self.pages.forEach { $0.contentInset = newValue } }
  }

  var scrollIndicatorInsets: UIEdgeInsets {
    get { return self.tramPage.scrollIndicatorInsets }
    set { self.pages.forEach { $0.scrollIndicatorInsets = newValue } }
  }

  // MARK: - Init

  init() {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    // load view so we can select/deselect cells right away
    self.pages.forEach { _ = $0.view }
    self.dataSource = self

    self.initBindings()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initBindings() {
    self.viewModel.outputs.tramLines
      .drive(self.tramPage.viewModel.inputs.linesChanged)
      .disposed(by: disposeBag)

    self.viewModel.outputs.busLines
      .drive(self.busPage.viewModel.inputs.linesChanged)
      .disposed(by: disposeBag)

    self.viewModel.outputs.selectedTramLines
      .drive(self.tramPage.viewModel.inputs.selectedLinesChanged)
      .disposed(by: disposeBag)

    self.viewModel.outputs.selectedBusLines
      .drive(self.busPage.viewModel.inputs.selectedLinesChanged)
      .disposed(by: disposeBag)
  }

  // MARK: - Override

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setViewControllers([self.tramPage], direction: .forward, animated: false, completion: nil)
  }

  // MARK: - Methods

  func setCurrentPage(_ lineType: LineType, animated: Bool) {
    typealias Direction = UIPageViewControllerNavigationDirection

    let isTram    = lineType == .tram
    let page      = isTram ? self.tramPage     : self.busPage
    let direction = isTram ? Direction.reverse : Direction.forward

    self.setViewControllers([page], direction: direction, animated: animated, completion: nil)
  }
}

// MARK: UIPageViewControllerDataSource

extension LineSelectionViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = self.index(of: viewController)
      else { return nil }

    let previousIndex = index - 1
    return previousIndex >= 0 ? self.pages[previousIndex] : nil
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = self.index(of: viewController)
      else { return nil }

    let nextIndex = index + 1
    return nextIndex < self.pages.count ? self.pages[nextIndex] : nil
  }

  private func index(of viewController: UIViewController) -> Int? {
    return self.pages.index { $0 === viewController }
  }
}
