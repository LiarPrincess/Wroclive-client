//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

class MainController: UIViewController {

  //MARK: Properties

  @IBOutlet weak var buttonCurrentLocation: UIButton!
  @IBOutlet weak var buttonSearch: UIButton!
  @IBOutlet weak var buttonFavorites: UIButton!
  @IBOutlet weak var buttonSettings: UIButton!
  @IBOutlet weak var buttonContainer: UIVisualEffectView!

  lazy var allButtons: [UIButton] = {
    return [self.buttonCurrentLocation, self.buttonSearch, self.buttonFavorites, self.buttonSettings]
  }()

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
    self.buttonContainer.addBorder(edges: .top, color: UIColor(white: 0.80, alpha: 0.65), thickness: 0.75)

    //[buttons] center and scale image
    for button in self.allButtons {
      button.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
      button.imageView?.contentMode = .scaleAspectFit
    }
  }

}
