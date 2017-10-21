//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

// swiftlint:disable identifier_name

private class BundleHook {}

private func localizedString(_ key: String) -> String {
  let bundle = Bundle(for: BundleHook.self)
  return NSLocalizedString(key, bundle: bundle, comment: "")
}

struct Localizable {

  struct Search {
    static var cardTitle: String { return localizedString("Search_CardTitle") }
    static var search:    String { return localizedString("Search_Search") }
    static var loading:   String { return localizedString("Search_Loading") }
  }

  struct Bookmarks {
    static var cardTitle:          String { return localizedString("Bookmarks_CardTitle") }
    static var editEdit:           String { return localizedString("Bookmarks_Edit_Edit") }
    static var editDone:           String { return localizedString("Bookmarks_Edit_Done") }
    static var placeholderTitle:   String { return localizedString("Bookmarks_Placeholder_Title") }
    static var placeholderContent: String { return localizedString("Bookmarks_Placeholder_Content") }
  }

  struct Configuration {
    static var Title:  String { return localizedString("Configuration_Title") }
    static var Footer: String { return localizedString("Configuration_Footer") }

    struct Cells {
      static var colors:   String { return localizedString("Configuration_Cell_Colours") }
      static var share:    String { return localizedString("Configuration_Cell_Share") }
      static var tutorial: String { return localizedString("Configuration_Cell_Tutorial") }
      static var contact:  String { return localizedString("Configuration_Cell_Contact") }
      static var rate:     String { return localizedString("Configuration_Cell_Rate") }
    }
  }

  struct Controls {
    struct LineSelection {
      static var regular:   String { return localizedString("LineSelection_SectionName_Regular") }
      static var express:   String { return localizedString("LineSelection_SectionName_Express") }
      static var peakHour:  String { return localizedString("LineSelection_SectionName_PeakHour") }
      static var suburban:  String { return localizedString("LineSelection_SectionName_Suburban") }
      static var zone:      String { return localizedString("LineSelection_SectionName_Zone") }
      static var limited:   String { return localizedString("LineSelection_SectionName_Limited") }
      static var temporary: String { return localizedString("LineSelection_SectionName_Temporary") }
      static var night:     String { return localizedString("LineSelection_SectionName_Night") }
    }

    struct LineTypeSelection {
      static var tram: String { return localizedString("LineTypeSelection_Tram") }
      static var bus:  String { return localizedString("LineTypeSelection_Bus") }
    }
  }

  struct Presentation {
    struct InAppPurchase {
      static var upgrade: String { return localizedString("Presentation_InAppPurchase_Upgrade") }
      static var restoreText: String { return localizedString("Presentation_InAppPurchase_Restore_Text") }
      static var restoreLink: String { return localizedString("Presentation_InAppPurchase_Restore_Link") }

      struct BookmarksPage {
        static var title:   String { return localizedString("Presentation_InAppPurchase_Bookmarks_Title") }
        static var caption: String { return localizedString("Presentation_InAppPurchase_Bookmarks_Content") }
      }

      struct ColorsPage {
        static var title:   String { return localizedString("Presentation_InAppPurchase_Colors_Title") }
        static var caption: String { return localizedString("Presentation_InAppPurchase_Colors_Content") }
      }
    }

    struct Tutorial {
      static var skip: String { return localizedString("Presentation_Tutorial_Skip") }

      struct Page0 {
        static var title:   String { return localizedString("Presentation_Tutorial_Page0_Title") }
        static var caption: String { return localizedString("Presentation_Tutorial_Page0_Caption") }
      }

      struct Page1 {
        static var title:   String { return localizedString("Presentation_Tutorial_Page1_Title") }
        static var caption: String { return localizedString("Presentation_Tutorial_Page1_Caption") }
      }

      struct Page2 {
        static var title:   String { return localizedString("Presentation_Tutorial_Page2_Title") }
        static var caption: String { return localizedString("Presentation_Tutorial_Page2_Caption") }
      }
    }
  }

  struct Alerts {
    struct Location {
      struct Denied {
        static var title:    String { return localizedString("Alert_Denied_Title") }
        static var content:  String { return localizedString("Alert_Denied_Content") }
        static var settings: String { return localizedString("Alert_Denied_Settings") }
        static var ok:       String { return localizedString("Alert_Denied_Ok") }
      }

      struct DeniedGlobally {
        static var title:   String { return localizedString("Alert_GloballyDenied_Title") }
        static var content: String { return localizedString("Alert_GloballyDenied_Content") }
        static var ok:      String { return localizedString("Alert_GloballyDenied_Ok") }
      }

      struct InvalidCity {
        static var title:   String { return localizedString("Alert_InvalidCity_Title") }
        static var content: String { return localizedString("Alert_InvalidCity_Message") }
        static var no:      String { return localizedString("Alert_InvalidCity_No") }
        static var yes:     String { return localizedString("Alert_InvalidCity_Yes") }
      }
    }

    struct Bookmark {
      struct NoLinesSelected {
        static var title:   String { return localizedString("Alert_Bookmark_NoLinesSelected_Title") }
        static var content: String { return localizedString("Alert_Bookmark_NoLinesSelected_Content") }
        static var ok:      String { return localizedString("Alert_Bookmark_NoLinesSelected_Ok") }
      }

      struct NameInput {
        static var title:       String { return localizedString("Alert_Bookmark_NameInput_Title") }
        static var content:     String { return localizedString("Alert_Bookmark_NameInput_Content") }
        static var placeholder: String { return localizedString("Alert_Bookmark_NameInput_Placeholder") }
        static var cancel:      String { return localizedString("Alert_Bookmark_NameInput_Cancel") }
        static var save:        String { return localizedString("Alert_Bookmark_NameInput_Save") }
      }
    }

    struct Network {
      struct NoInternet {
        static var title:    String { return localizedString("Alert_Network_NoInternet_Title") }
        static var content:  String { return localizedString("Alert_Network_NoInternet_Content") }
        static var tryAgain: String { return localizedString("Alert_Network_NoInternet_TryAgain") }
      }

      struct ConnectionError {
        static var title:    String { return localizedString("Alert_Network_ConnectionError_Title") }
        static var content:  String { return localizedString("Alert_Network_ConnectionError_Content") }
        static var tryAgain: String { return localizedString("Alert_Network_ConnectionError_TryAgain") }
      }
    }
  }

  struct Share {
    static var text: String { return localizedString("Configuration_Share_Content") }
  }

  struct Theme {
    static var tint: String { return localizedString("Configuration_Theme_Tint") }
    static var tram: String { return localizedString("Configuration_Theme_Tram") }
    static var bus:  String { return localizedString("Configuration_Theme_Bus") }
  }
}
