// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public enum CardPanelConstants {

  public static let topCornerRadius = CGFloat(12.0)
  public static let chevronViewSpace = ChevronView.nominalSize.height

  public enum DimmingView {
    public static let color = UIColor.black
    public static let alpha = CGFloat(0.4)
  }

  public enum AnimationDurations {
    public static let present = TimeInterval(0.3)
    public static let dismiss = TimeInterval(0.3)
  }

  public enum DismissGesture {
    public static let elasticThreshold = CGFloat(120)
    public static let dismissThreshold = CGFloat(240)

    public static let translationFactor = CGFloat(0.5)
  }
}
