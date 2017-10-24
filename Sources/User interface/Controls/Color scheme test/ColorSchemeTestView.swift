//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants = ColorSchemeTestViewConstants

class ColorSchemeTestView: UIView {

  // MARK: - Properties

  private let backgroundLayer = UIImageView()
  private let tramLayer       = UIImageView()
  private let busLayer        = UIImageView()
  private let toolbarLayer    = UIImageView()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
    self.setCurrentColorScheme()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundLayer.image       = Images.Colors.background
    self.backgroundLayer.contentMode = .scaleToFill

    self.addSubview(self.backgroundLayer)
    self.backgroundLayer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.tramLayer.image = Images.Colors.trams.withRenderingMode(.alwaysTemplate)
    self.tramLayer.contentMode = .scaleToFill

    self.addSubview(self.tramLayer)
    self.tramLayer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.busLayer.image = Images.Colors.busses.withRenderingMode(.alwaysTemplate)
    self.busLayer.contentMode = .scaleToFill

    self.addSubview(self.busLayer)
    self.busLayer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    let toolbarImage = Images.Colors.toolbar
    self.toolbarLayer.image       = toolbarImage.withRenderingMode(.alwaysTemplate)
    self.toolbarLayer.contentMode = .scaleToFill

    self.addSubview(self.toolbarLayer)
    self.toolbarLayer.snp.makeConstraints { make in
      let acpectRatioInv = toolbarImage.size.height / toolbarImage.size.width

      make.height.equalTo(toolbarLayer.snp.width).multipliedBy(acpectRatioInv)
      make.left.bottom.right.equalToSuperview()
    }
  }

  // MARK: - Set colors

  func setCurrentColorScheme() {
    let colorScheme = Managers.theme.colors
    let tintColor   = colorScheme.tintColor
    let tramColor   = colorScheme.tramColor
    let busColor    = colorScheme.busColor
    self.setColors(tintColor: tintColor, tramColor: tramColor, busColor: busColor)
  }

  func setColors(tintColor: TintColor, tramColor: VehicleColor, busColor: VehicleColor) {
    self.tramLayer.tintColor = tramColor.value
    self.busLayer.tintColor  = busColor.value
    self.toolbarLayer.tintColor = tintColor.value
  }
}
