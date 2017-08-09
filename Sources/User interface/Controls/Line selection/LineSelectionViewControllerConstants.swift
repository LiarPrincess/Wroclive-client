//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct LineSelectionViewControllerConstants {

  struct Layout {
    struct SectionHeader {
      static let topInset:    CGFloat = 16.0
      static let bottomInset: CGFloat =  8.0

      static let fallbackHeight: CGFloat = topInset + 28.0 + bottomInset
    }

    struct Cell {
      static let margin:  CGFloat =  2.0
      static let minSize: CGFloat = 50.0

      static let cornerRadius: CGFloat = 8.0
    }
  }

  struct Localization {
    static var regular:   String { return NSLocalizedString("LineSelection_SectionName_Regular",   comment: "") }
    static var express:   String { return NSLocalizedString("LineSelection_SectionName_Express",   comment: "") }
    static var peakHour:  String { return NSLocalizedString("LineSelection_SectionName_PeakHour",  comment: "") }
    static var suburban:  String { return NSLocalizedString("LineSelection_SectionName_Suburban",  comment: "") }
    static var zone:      String { return NSLocalizedString("LineSelection_SectionName_Zone",      comment: "") }
    static var limited:   String { return NSLocalizedString("LineSelection_SectionName_Limited",   comment: "") }
    static var temporary: String { return NSLocalizedString("LineSelection_SectionName_Temporary", comment: "") }
    static var night:     String { return NSLocalizedString("LineSelection_SectionName_Night",     comment: "") }
  }
}
