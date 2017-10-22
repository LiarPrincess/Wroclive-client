//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = ColorSchemeTestViewConstants

class ColorSchemeTestView: UIView {

  // MARK: - Properties

  private let backgroundImageView = UIImageView()
  private let tramPin              = VehiclePinView()
  private let busPin           = VehiclePinView()
  private let toolbarImageView    = UIImageView()

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
    backgroundImageView.image       = Images.mapBackground
    backgroundImageView.contentMode = .scaleToFill

    self.addSubview(self.backgroundImageView)
    self.backgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.tramPin.angle = Constants.TramPin.angle

    self.addSubview(self.tramPin)
    self.tramPin.snp.makeConstraints { make in
      make.width.height.equalTo(Constants.Layout.pinSize)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(Constants.TramPin.centerYOffset)
    }

    self.busPin.angle = Constants.BusPin.angle

    self.addSubview(self.busPin)
    busPin.snp.makeConstraints { make in
      make.width.height.equalTo(Constants.Layout.pinSize)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(Constants.BusPin.centerYOffset)
    }

    let toolbarImage = Images.Toolbars.red
    self.toolbarImageView.image       = Images.Toolbars.red
    self.toolbarImageView.contentMode = .scaleToFill

    self.addSubview(self.toolbarImageView)
    self.toolbarImageView.snp.makeConstraints { make in
      let toolbarImageAspect = toolbarImage.size.height / toolbarImage.size.width

      make.height.equalTo(toolbarImageView.snp.width).multipliedBy(toolbarImageAspect)
      make.left.bottom.right.equalToSuperview()
    }
  }

  private func setCurrentColorScheme() {
    let colorScheme = Managers.theme.colors
    let tintColor   = colorScheme.tintColor
    let tramColor   = colorScheme.tramColor
    let busColor    = colorScheme.busColor
    self.setColors(tintColor: tintColor, tramColor: tramColor, busColor: busColor)
  }

  // MARK: - Set colors

  func setColors(tintColor: TintColor, tramColor: VehicleColor, busColor: VehicleColor) {
    self.toolbarImageView.image = self.toolbarImage(for: tintColor)
    self.tramPin.tintColor = tramColor.value
    self.busPin.tintColor  = busColor.value
  }

  private func toolbarImage(for tintColor: TintColor) -> UIImage {
    switch tintColor {
    case .red:    return Images.Toolbars.red
    case .blue:   return Images.Toolbars.blue
    case .green:  return Images.Toolbars.green
    case .orange: return Images.Toolbars.orange
    case .pink:   return Images.Toolbars.pink
    case .black:  return Images.Toolbars.black
    }
  }
}
