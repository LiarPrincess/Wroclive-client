// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import SnapshotTesting
import WrocliveFramework

// MARK: - Device

public struct SnapshotDevice {

  public let name: String
  public let config: ViewImageConfig

  public static let iPhoneSE = SnapshotDevice(name: "iPhoneSE", config: .iPhoneSe)
  public static let iPhone8 = SnapshotDevice(name: "iPhone8", config: .iPhone8)
  public static let iPhone8Plus = SnapshotDevice(name: "iPhone8 Plus", config: .iPhone8Plus)
  public static let iPhoneX = SnapshotDevice(name: "iPhoneX", config: .iPhoneX)
  // Well… technically there is no X max, but it is easier to type than XS max.
  public static let iPhoneXMax = SnapshotDevice(name: "iPhoneX Max", config: .iPhoneXsMax)
  public static let iPhoneXr = SnapshotDevice(name: "iPhoneXr", config: .iPhoneXr)

  private init(name: String, config: ViewImageConfig) {
    self.name = name
    self.config = config
  }
}

/// Devices for which we will create snapshots
private let devices: [SnapshotDevice] = [.iPhoneSE, .iPhone8, .iPhoneX]

// MARK: - Locales

/// Locales for which we will create snapshots
private let locales: [Localizable.Locale] = [.en, .pl]

// MARK: - Directory

/// Directory that will hold all of the snapshots
private let rootSnapshotDirectory = URL(fileURLWithPath: #file, isDirectory: false)
  .deletingLastPathComponent()
  .appendingPathComponent("__Snapshots__")

// MARK: - SnapshotTestCase

public protocol SnapshotTestCase {}

extension SnapshotTestCase {

  // MARK: - Assert snapshot

  public func assertSnapshot<Value, Format>(
    matching value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
  ) {
    let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
    let fileName = fileUrl.deletingPathExtension().lastPathComponent
    let snapshotDirectory = rootSnapshotDirectory.appendingPathComponent(fileName)

    let failure = verifySnapshot(
      matching: try value(),
      as: snapshotting,
      named: name,
      record: recording,
      snapshotDirectory: snapshotDirectory.absoluteString,
      timeout: timeout,
      file: file,
      testName: testName,
      line: line
    )

    guard let message = failure else { return }
    XCTFail(message, file: file, line: line)
  }

  // MARK: - On all devices in all locales

  public typealias CreateSnapshots = (UIViewController, SnapshotErrorLocation) -> Void

  public func onAllDevicesInAllLocales(fn: (CreateSnapshots) -> Void) {
    for locale in locales {
      Localizable.setLocale(locale)

      for device in devices {
        var counter = 1

        func snapshot(view: UIViewController,
                      errorLocation: SnapshotErrorLocation) {
          let name = "\(counter)-\(device.name)-\(locale)"
          counter += 1

          self.assertSnapshot(
            matching: view,
            as: .image(on: device.config),
            named: name,
            file: errorLocation.file,
            testName: errorLocation.function,
            line: errorLocation.line
          )
        }

        fn(snapshot(view:errorLocation:))
      }
    }
  }

  // MARK: - On all devices

  public func onAllDevices(fn: (CreateSnapshots) -> Void) {
    for device in devices {
      var counter = 1

      func snapshot(view: UIViewController,
                    errorLocation: SnapshotErrorLocation) {
        let name = "\(counter)-\(device.name)"
        counter += 1

        self.assertSnapshot(
          matching: view,
          as: .image(on: device.config),
          named: name,
          file: errorLocation.file,
          testName: errorLocation.function,
          line: errorLocation.line
        )
      }

      fn(snapshot(view:errorLocation:))
    }
  }

  // MARK: - Dark mode

  public func inDarkMode(fn: (CreateSnapshots) -> Void) {
    // All dark mode screenshots should be in PL,
    // as this will be the most common language.
    Localizable.setLocale(.pl)

    // We will only test 'iPhoneX', just to check if it works.
    let device = SnapshotDevice.iPhoneX
    let traits = UITraitCollection(userInterfaceStyle: .dark)

    var counter = 1

    func snapshot(view: UIViewController,
                  errorLocation: SnapshotErrorLocation) {
      let name = "\(counter)-\(device.name)"
      counter += 1

      self.assertSnapshot(
        matching: view,
        as: .image(on: device.config, traits: traits),
        named: name,
        file: errorLocation.file,
        testName: errorLocation.function,
        line: errorLocation.line
      )
    }

    fn(snapshot(view:errorLocation:))
  }
}

// MARK: - SnapshotErrorLocation

// We can't have default argument values in 'typealias CreateSnapshots',
// so we have to do it in a different way.
public struct SnapshotErrorLocation {

  internal let file: StaticString
  internal let function: String
  internal let line: UInt

  public static func errorOnThisLine(file: StaticString = #file,
                                     function: String = #function,
                                     line: UInt = #line) -> SnapshotErrorLocation {
    return SnapshotErrorLocation(file: file, function: function, line: line)
  }
}
