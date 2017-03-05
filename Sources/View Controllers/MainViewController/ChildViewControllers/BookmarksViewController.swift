//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import ReSwift

struct BookmarksViewControllerConstants {
  static let cellIdentifier = "BookmarkCell"
}

class BookmarksViewController: UIViewController {

  //MARK: - Static

  static let identifier = "BookmarksViewController"

  //MARK: - Properties

  fileprivate let dataSource = BookmarksDataSource()

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var tableView: UITableView!

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self.dataSource
    self.tableView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    store.subscribe(self) { state in state.bookmarksState }
  }

  override func viewDidDisappear(_ animated: Bool) {
    //hack: FIRST dismiss THEN dispatch action (reason: dismiss in InteractiveTransition controller)
    store.dispatch(SetBookmarksVisibility(false))
    super.viewDidDisappear(animated)
    store.unsubscribe(self)
  }

  //MARK: - Actions

  @IBAction func closeButtonPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

}

//MARK: - StoreSubscriber

extension BookmarksViewController: StoreSubscriber {

  func newState(state: BookmarksState) {
    guard state.visible else {
      return
    }

    if self.dataSource.bookmarks != state.bookmarks {
      self.dataSource.bookmarks = state.bookmarks
    }
  }

}

//MARK: - TableViewDelegate

extension BookmarksViewController: UITableViewDelegate {

  //MARK: - Display

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? BookmarkCell else {
      fatalError("Invalid cell type passed to BookmarksViewController.UITableViewDelegate")
    }

    cell.labelTramLines.textColor = self.view.tintColor
    cell.labelBusLines.textColor = self.view.tintColor
  }

  //MARK: - Height

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.rowHeight
  }

}
