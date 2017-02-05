//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

class MainController: UIViewController {

  //MARK: Properties

  @IBOutlet weak var buttonContainer: UIVisualEffectView!

  //MARK: Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.applyVisualStyles()
  }

  //MARK: Gesture recognizers
  
  
  //MARK: Methods

}

extension MainController {

  func applyVisualStyles() {

    //[buttonContainer] top border
    self.buttonContainer.addBorder(edges: .top, color: UIColor(white: 0.75, alpha: 0.5), thickness: 1.0)
  }

}
