//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

class SearchPanelViewController: UIViewController {

  //MARK: - Properties

  //MARK: - Overriden

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    store.subscribe(self) { state in state.searchState }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    store.unsubscribe(self)
  }

  //MARK: - Actions

  @IBAction func closeButtonPressed(_ sender: Any) {
    store.dispatch(SetSearchVisibility(false))
  }

}

//MARK: - StoreSubscriber

extension SearchPanelViewController: StoreSubscriber {

  func newState(state: SearchState) {
    guard state.visible else {
      self.dismiss(animated: true, completion: nil)
      return
    }

    //code
  }
  
}
