//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

struct AlertManagerImplLocalization {
  struct Location {
    struct Denied {
      static var title:    String { return NSLocalizedString("Alert_Denied_Title",    comment: "") }
      static var content:  String { return NSLocalizedString("Alert_Denied_Content",  comment: "") }
      static var settings: String { return NSLocalizedString("Alert_Denied_Settings", comment: "") }
      static var ok:       String { return NSLocalizedString("Alert_Denied_Ok",       comment: "") }
    }

    struct DeniedGlobally {
      static var title:   String { return NSLocalizedString("Alert_GloballyDenied_Title",   comment: "") }
      static var content: String { return NSLocalizedString("Alert_GloballyDenied_Content", comment: "") }
      static var ok:      String { return NSLocalizedString("Alert_GloballyDenied_Ok",      comment: "") }
    }
  }

  struct Bookmark {
    struct NoLinesSelected {
      static var title:   String { return NSLocalizedString("Alert_Bookmark_NoLinesSelected_Title",   comment: "") }
      static var content: String { return NSLocalizedString("Alert_Bookmark_NoLinesSelected_Content", comment: "") }
      static var ok:      String { return NSLocalizedString("Alert_Bookmark_NoLinesSelected_Ok",      comment: "") }
    }

    struct NameInput {
      static var title:       String { return NSLocalizedString("Alert_Bookmark_NameInput_Title",       comment: "") }
      static var content:     String { return NSLocalizedString("Alert_Bookmark_NameInput_Content",     comment: "") }
      static var placeholder: String { return NSLocalizedString("Alert_Bookmark_NameInput_Placeholder", comment: "") }
      static var cancel:      String { return NSLocalizedString("Alert_Bookmark_NameInput_Cancel",      comment: "") }
      static var save:        String { return NSLocalizedString("Alert_Bookmark_NameInput_Save",        comment: "") }
    }

    struct Instructions {
      static var title:   String { return NSLocalizedString("Alert_Bookmark_Instructions_Title",   comment: "") }
      static var content: String { return NSLocalizedString("Alert_Bookmark_Instructions_Content", comment: "") }
      static var ok:      String { return NSLocalizedString("Alert_Bookmark_Instructions_Ok",      comment: "") }
    }
  }

  struct Network {
    struct NoInternet {
      static var title:    String { return NSLocalizedString("Alert_Network_NoInternet_Title",    comment: "") }
      static var content:  String { return NSLocalizedString("Alert_Network_NoInternet_Content",  comment: "") }
      static var tryAgain: String { return NSLocalizedString("Alert_Network_NoInternet_TryAgain", comment: "") }
    }

    struct ConnectionError {
      static var title:    String { return NSLocalizedString("Alert_Network_ConnectionError_Title",    comment: "") }
      static var content:  String { return NSLocalizedString("Alert_Network_ConnectionError_Content",  comment: "") }
      static var tryAgain: String { return NSLocalizedString("Alert_Network_ConnectionError_TryAgain", comment: "") }
    }
  }
}
