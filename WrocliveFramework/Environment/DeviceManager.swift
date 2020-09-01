// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol DeviceManagerType {

  // MARK: - Device

  /// iPhone 5s
  var model: String { get }

  /// iOS, watchOS, tvOS
  var systemName: String { get }

  /// 10.2
  var systemVersion: String { get }

  // MARK: - Screen

  /// Point to pixel ratio
  var screenScale: CGFloat { get }

  /// Screen resolution
  var screenBounds: CGRect { get }
}

public struct DeviceManager: DeviceManagerType {

  public let model: String
  public let systemName: String
  public let systemVersion: String

  public let screenScale: CGFloat
  public let screenBounds: CGRect

  public init(model: String, device: UIDevice, screen: UIScreen) {
    self.model = model
    self.systemName = device.systemName
    self.systemVersion = device.systemVersion
    self.screenScale = screen.scale
    self.screenBounds = screen.bounds
  }

  // MARK: - Precise model

  // See: https://stackoverflow.com/a/11197770
  internal static func getPreciseModel() -> String {
    var info = utsname()
    uname(&info)

    let machine = info.machine
    let mirror = Mirror(reflecting: machine)

    var result = ""
    for child in mirror.children {
      guard let value = child.value as? Int8 else {
        continue
      }

      if value == 0 { // null terminator
        break
      } else if value > 0 {
        let ascii = UInt8(value)
        let char = String(UnicodeScalar(ascii))
        result.append(char)
      }
    }

    return Self.knownDeviceModels[result] ?? result
  }

  private static let knownDeviceModels = [
    // Simulator
    "i386": "Simulator",
    "x86_64": "Simulator",
    // iPhone
    "iPhone1,1": "iPhone",
    "iPhone1,2": "iPhone 3G",
    "iPhone2,1": "iPhone 3GS",
    "iPhone3,1": "iPhone 4",
    "iPhone3,2": "iPhone 4",
    "iPhone3,3": "iPhone 4",
    "iPhone4,1": "iPhone 4S",
    "iPhone5,1": "iPhone 5",
    "iPhone5,2": "iPhone 5",
    "iPhone5,3": "iPhone 5c",
    "iPhone5,4": "iPhone 5c",
    "iPhone6,1": "iPhone 5s",
    "iPhone6,2": "iPhone 5s",
    "iPhone7,1": "iPhone 6 Plus",
    "iPhone7,2": "iPhone 6",
    "iPhone8,1": "iPhone 6S",
    "iPhone8,2": "iPhone 6S Plus",
    "iPhone8,4": "iPhone SE",
    "iPhone9,1": "iPhone 7 ",
    "iPhone9,3": "iPhone 7 ",
    "iPhone9,2": "iPhone 7 Plus",
    "iPhone9,4": "iPhone 7 Plus",
    "iPhone10,1": "iPhone 8",
    "iPhone10,4": "iPhone 8",
    "iPhone10,2": "iPhone 8 Plus",
    "iPhone10,5": "iPhone 8 Plus",
    "iPhone10,3": "iPhone X",
    "iPhone10,6": "iPhone X",
    "iPhone11,2": "iPhone XS",
    "iPhone11,4": "iPhone XS Max",
    "iPhone11,6": "iPhone XS Max China",
    "iPhone11,8": "iPhone XR",
    "iPhone12,1": "iPhone 11",
    "iPhone12,3": "iPhone 11 Pro",
    "iPhone12,5": "iPhone 11 Pro Max",
    "iPhone12,8": "iPhone SE (2nd Gen)",
    // iPad
    "iPad1,1": "iPad",
    "iPad1,2": "iPad",
    "iPad2,1": "iPad 2",
    "iPad2,2": "iPad 2",
    "iPad2,3": "iPad 2",
    "iPad2,4": "iPad 2",
    "iPad2,5": "iPad Mini",
    "iPad2,6": "iPad Mini",
    "iPad2,7": "iPad Mini",
    "iPad3,1": "iPad 3",
    "iPad3,2": "iPad 3",
    "iPad3,3": "iPad 3",
    "iPad3,4": "iPad 4",
    "iPad3,5": "iPad 4",
    "iPad3,6": "iPad 4",
    "iPad4,1": "iPad AIR",
    "iPad4,2": "iPad AIR",
    "iPad4,3": "iPad AIR",
    "iPad4,4": "iPad Mini 2",
    "iPad4,5": "iPad Mini 2",
    "iPad4,6": "iPad Mini 2",
    "iPad4,7": "iPad Mini 3",
    "iPad4,8": "iPad Mini 3",
    "iPad4,9": "iPad Mini 3",
    "iPad5,1": "iPad Mini 4",
    "iPad5,2": "iPad Mini 4",
    "iPad5,3": "iPad AIR 2",
    "iPad5,4": "iPad AIR 2",
    "iPad6,3": "iPad PRO 9.7",
    "iPad6,4": "iPad PRO 9.7",
//    "iPad6,4": "iPad PRO 9.7",
    "iPad6,7": "iPad PRO 12.9",
    "iPad6,8": "iPad PRO 12.9",
    "iPad6,11": "iPad (5th generation)",
    "iPad6,12": "iPad (5th generation)",
    "iPad7,1": "iPad PRO 12.9 (2nd Gen)",
    "iPad7,2": "iPad PRO 12.9 (2nd Gen)",
//    "iPad7,2": "iPad PRO 12.9 (2nd Gen)",
    "iPad7,3": "iPad PRO 10.5",
    "iPad7,4": "iPad PRO 10.5",
    "iPad7,5": "iPad (6th Gen)",
    "iPad7,6": "iPad (6th Gen)",
    "iPad7,11": "iPad (7th Gen)",
    "iPad7,12": "iPad (7th Gen)",
    "iPad8,1": "iPad PRO 11",
    "iPad8,2": "iPad PRO 11",
    "iPad8,3": "iPad PRO 11",
    "iPad8,4": "iPad PRO 11",
    "iPad8,5": "iPad PRO 12.9 (3rd Gen)",
    "iPad8,6": "iPad PRO 12.9 (3rd Gen)",
    "iPad8,7": "iPad PRO 12.9 (3rd Gen)",
    "iPad8,8": "iPad PRO 12.9 (3rd Gen)",
    "iPad8,9": "iPad PRO 11 (2nd Gen)",
    "iPad8,10": "iPad PRO 11 (2nd Gen)",
    "iPad8,11": "iPad PRO 12.9 (4th Gen)",
    "iPad8,12": "iPad PRO 12.9 (4th Gen)",
    "iPad11,1": "iPad mini 5th Gen",
    "iPad11,2": "iPad mini 5th Gen",
    "iPad11,3": "iPad Air 3rd Gen",
    "iPad11,4": "iPad Air 3rd Gen",
    // iPod Touch
    "iPod1,1": "iPod Touch",
    "iPod2,1": "iPod Touch 2nd Generation",
    "iPod3,1": "iPod Touch 3rd Generation",
    "iPod4,1": "iPod Touch 4th Generation",
    "iPod5,1": "iPod Touch 5th Generation",
    "iPod7,1": "iPod Touch 6th Generation",
    "iPod9,1": "iPod Touch 7th Generation"
  ]
}
