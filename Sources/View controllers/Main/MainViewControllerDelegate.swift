//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol MainViewControllerDelegate: class {
  func mainViewControllerDidAppear(_ viewController: MainViewController)

  func mainViewControllerDidTapSearchButton(_ viewController: MainViewController)
  func mainViewControllerDidTapTapBookmarksButton(_ viewController: MainViewController)
  func mainViewControllerDidTapConfigurationButton(_ viewController: MainViewController)
}
