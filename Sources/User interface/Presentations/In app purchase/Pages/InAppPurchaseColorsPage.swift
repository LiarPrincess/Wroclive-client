//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants    = InAppPurchasePresentationConstants
private typealias Localization = Localizable.Presentation.InAppPurchase.Colors

private struct ColorSchemePreset {
  let tint: TintColor
  let tram: VehicleColor
  let bus:  VehicleColor
}

class InAppPurchaseColorsPage: InAppPurchasePresentationPage {

  // MARK: - Properties

  private var timer: Timer?
  private let content = ColorSchemeTestView()

  private var currentPresetIndex = 0

  private let presets: [ColorSchemePreset] = {
    let p0 = ColorSchemePreset(tint: .pink,  tram: .green,  bus: .pink)
    let p1 = ColorSchemePreset(tint: .blue,  tram: .orange, bus: .blue)
    let p2 = ColorSchemePreset(tint: .black, tram: .black,  bus: .red)
    return [p0, p1, p2]
  }()

  // MARK: - Init

  init() {
    super.init(content: content, title: Localization.title, caption: Localization.caption)
    self.showCurrentPreset()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.startTimer()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.stopTimer()
  }

  // MARK: - Presets

  private func showCurrentPreset() {
    let preset = self.presets[self.currentPresetIndex]
    self.content.setColors(tint: preset.tint, tram: preset.tram, bus: preset.bus)
  }

  private func showNextPreset() {
    self.currentPresetIndex = (self.currentPresetIndex + 1) % self.presets.count
    self.showCurrentPreset()
  }

  // MARK: - Timer

  private func startTimer() {
    self.stopTimer()

    let interval = Constants.Timer.colorsChangeInterval
    self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    self.timer?.tolerance = interval * 0.1
  }

  @objc func timerFired(timer: Timer) {
    self.showNextPreset()
  }

  private func stopTimer() {
    self.timer?.invalidate()
    self.timer = nil
  }
}
