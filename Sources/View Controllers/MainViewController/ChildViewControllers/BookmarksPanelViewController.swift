//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import ReSwift

class BookmarksPanelViewController: UIViewController {

  //MARK: - Properties

  //MARK: - Overriden

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    store.subscribe(self) { state in state.bookmarksState }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    store.unsubscribe(self)
  }

  //MARK: - Actions

  @IBAction func closeButtonPressed(_ sender: Any) {
    store.dispatch(SetBookmarksVisibility(false))
  }

}

//MARK: - StoreSubscriber

extension BookmarksPanelViewController: StoreSubscriber {

  func newState(state: BookmarksState) {
    guard state.visible else {
      self.dismiss(animated: true, completion: nil)
      return
    }

    //code
  }

}
