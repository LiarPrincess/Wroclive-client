//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {

  //MARK: - Properties

  @IBOutlet weak var buttonUserTracking: UserTrackingButton!
  @IBOutlet weak var buttonSearch: UIButton!
  @IBOutlet weak var buttonFavorites: UIButton!
  @IBOutlet weak var buttonSettings: UIButton!
  @IBOutlet weak var buttonContainer: UIVisualEffectView!

  lazy var allButtons: [UIButton] = {
    return [self.buttonUserTracking, self.buttonSearch, self.buttonFavorites, self.buttonSettings]
  }()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.applyVisualStyles()
  }

  //MARK: - Navigation

  //MARK: - Actions

}

//MARK: - User interface

extension MainViewController {

  func applyVisualStyles() {
    
    //[buttons] center images
    for button in self.allButtons {
      let verticalInset = button.bounds.height / 4.0
      button.imageEdgeInsets = UIEdgeInsets(top: verticalInset, left: 0.0, bottom: verticalInset, right: 0.0)
      button.imageView?.contentMode = .scaleAspectFit
    }
  }

}
