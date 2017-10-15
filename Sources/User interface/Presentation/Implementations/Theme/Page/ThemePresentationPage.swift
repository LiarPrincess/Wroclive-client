//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ThemePresentationPage: UIViewController {

  // MARK: - Properties

  private let imageView = UIImageView()

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.imageView.image       = #imageLiteral(resourceName: "Image_Share")
    self.imageView.contentMode = .scaleAspectFit

    self.view.addSubview(self.imageView)
    self.imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
