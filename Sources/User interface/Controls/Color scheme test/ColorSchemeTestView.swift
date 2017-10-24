//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants = ColorSchemeTestViewConstants

class ColorSchemeTestView: UIView {

  // MARK: - Properties

  private let backgroundImageView = UIImageView()
  private let tramLayer           = UIImageView()
  private let busLayer            = UIImageView()
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
    self.backgroundImageView.image       = Images.mapBackground
    self.backgroundImageView.contentMode = .scaleToFill

    self.addSubview(self.backgroundImageView)
    self.backgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.tramLayer.image = Images.InAppPurchase.trams.withRenderingMode(.alwaysTemplate)
    self.tramLayer.contentMode = .scaleToFill

    self.addSubview(self.tramLayer)
    self.tramLayer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.busLayer.image = Images.InAppPurchase.busses.withRenderingMode(.alwaysTemplate)
    self.busLayer.contentMode = .scaleToFill

    self.addSubview(self.busLayer)
    self.busLayer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
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
    self.toolbarImageView.image = self.toolbarImage(for: tintColor)
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
