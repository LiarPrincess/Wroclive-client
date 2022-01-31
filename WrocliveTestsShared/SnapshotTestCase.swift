// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import SnapshotTesting
import WrocliveFramework

// MARK: - Settings

/// Devices for which we will create snapshots
private let devices: [Device] = [.iPhoneSE, .iPhone8, .iPhoneX]

/// Locales for which we will create snapshots
private let locales: [Localizable.Locale] = [.en, .pl]

private struct Device {

  fileprivate let name: String
  fileprivate let config: ViewImageConfig

  fileprivate static let iPhoneSE = Device(name: "iPhoneSE", config: .iPhoneSe)
  fileprivate static let iPhone8 = Device(name: "iPhone8", config: .iPhone8)
  fileprivate static let iPhone8Plus = Device(name: "iPhone8 Plus", config: .iPhone8Plus)
  fileprivate static let iPhoneX = Device(name: "iPhoneX", config: .iPhoneX)
  // Well… technically there is no X max, but it is easier to type than XS max.
  fileprivate static let iPhoneXMax = Device(name: "iPhoneX Max", config: .iPhoneXsMax)
  fileprivate static let iPhoneXr = Device(name: "iPhoneXr", config: .iPhoneXr)

  private init(name: String, config: ViewImageConfig) {
    self.name = name
    self.config = config
  }
}

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
    let snapshotDirectory = getSnapshotDirectory(swiftFilePath: file)

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

    if let message = failure {
      XCTFail(message, file: file, line: line)
    }
  }

  private func getSnapshotDirectory(swiftFilePath: StaticString) -> URL {
    let swiftFile = URL(fileURLWithPath: String(describing: swiftFilePath),
                        isDirectory: false)

    // '__Snapshots__' dir is located in the same dir as Swift file.
    let swiftFileDir = swiftFile.deletingLastPathComponent()
    let __snapshots__Dir = swiftFileDir.appendingPathComponent("__Snapshots__")

    let fm = FileManager.default
    if !fm.fileExists(atPath: __snapshots__Dir.path) {
      fatalError("Unable to find '__Snapshots__': \(__snapshots__Dir)")
    }

    // Final path is '__Snapshots__/SWIFT_FILE_NAME'.
    let swiftFileName = swiftFile.deletingPathExtension().lastPathComponent
    return __snapshots__Dir.appendingPathComponent(swiftFileName)
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
    let device = Device.iPhoneX
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
