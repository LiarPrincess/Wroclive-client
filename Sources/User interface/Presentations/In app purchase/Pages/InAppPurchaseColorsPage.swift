//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants    = InAppPurchasePresentationConstants
private typealias Localization = Localizable.Presentation.InAppPurchase.ColorsPage

class InAppPurchaseColorsPage: InAppPurchasePresentationPage {

  // MARK: - Properties

  private var timer: Timer?
  private let content = ColorSchemeTestView()

  // MARK: - Init

  init() {
    super.init(content: content, title: Localization.title, caption: Localization.caption)
    self.showRandomColors()
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

  // MARK: - Timer

  private func startTimer() {
    self.stopTimer()

    let interval = Constants.Timer.colorsChangeInterval
    self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    self.timer?.tolerance = interval * 0.1
  }

  @objc func timerFired(timer: Timer) {
    self.showRandomColors()
  }

  private func stopTimer() {
    self.timer?.invalidate()
  }

  // MARK: - Random scheme

  private func showRandomColors() {
    let tintColor = TintColor.allValues.random()
    let tramColor = VehicleColor.allValues.random()
    let busColor  = VehicleColor.allValues.random()
    self.content.setColors(tintColor: tintColor, tramColor: tramColor, busColor: busColor)
  }
}
