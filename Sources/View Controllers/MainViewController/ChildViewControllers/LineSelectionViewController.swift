//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

class LineSelectionViewController: UIViewController {

  //MARK: - Static

  static let identifier = "LineSelectionViewController"

  //MARK: - Properties

  //MARK: - Overriden

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    store.subscribe(self) { state in state.lineSelectionState }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    store.unsubscribe(self)
  }

  //MARK: - Actions

  @IBAction func closeButtonPressed(_ sender: Any) {
    store.dispatch(SetLineSelectionVisibility(false))
  }

}

//MARK: - StoreSubscriber

extension LineSelectionViewController: StoreSubscriber {

  func newState(state: LineSelectionState) {
    guard state.visible else {
      self.dismiss(animated: true, completion: nil)
      return
    }

    //code
  }
  
}
