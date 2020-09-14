// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import SnapshotTesting
import WrocliveFramework

// MARK: - Configuration

private typealias SnapshotDevice = (name: String, config: ViewImageConfig)
private let iPhoneSe = SnapshotDevice(name: "iPhoneSe", config: .iPhoneSe)
private let iPhone8 = SnapshotDevice(name: "iPhone8", config: .iPhone8)
private let iPhoneX = SnapshotDevice(name: "iPhoneX", config: .iPhoneX)

/// Devices for which we will create snapshots
private let devices = [iPhoneSe, iPhone8, iPhoneX]

/// Locales for which we will create snapshots
private let locales: [Localizable.Locale] = [.en, .pl]

/// Directory that will hold all of the snapshots
private let rootSnapshotDirectory = URL(fileURLWithPath: #file, isDirectory: false)
  .deletingLastPathComponent()
  .appendingPathComponent("__Snapshots__")

// MARK: - SnapshotTestCase

protocol SnapshotTestCase {}

extension SnapshotTestCase {

  // MARK: - On all devices in all locales

  typealias CreateSnapshots = (UIViewController, SnapshotErrorLocation) -> Void

  func onAllDevicesInAllLocales(file: StaticString = #file,
                                fn: (CreateSnapshots) -> Void) {

    let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
    let fileName = fileUrl.deletingPathExtension().lastPathComponent
    let snapshotDirectory = rootSnapshotDirectory.appendingPathComponent(fileName)

    for locale in locales {
      Localizable.setLocale(locale)

      for device in devices {
        self.assertSnapshot(device: device,
                            locale: locale,
                            snapshotDirectory: snapshotDirectory,
                            fn: fn)
      }
    }
  }

  private func assertSnapshot(device: SnapshotDevice,
                              locale: Localizable.Locale,
                              snapshotDirectory: URL,
                              fn: (CreateSnapshots) -> Void) {
    var counter = 1

    func snapshot(view: UIViewController,
                  errorLocation: SnapshotErrorLocation) {
      let name = "\(counter)-\(device.name)-\(locale)"
      counter += 1

      let failure = verifySnapshot(
        matching: view,
        as: .image(on: device.config),
        named: name,
        snapshotDirectory: snapshotDirectory.absoluteString,
        file: errorLocation.file,
        testName: errorLocation.function,
        line: errorLocation.line
      )

      guard let message = failure else { return }
      XCTFail(message, file: errorLocation.file, line: errorLocation.line)
    }

    fn(snapshot(view:errorLocation:))
  }
}

// We can't have default argument values in 'typealias CreateSnapshots',
// so we have to do it in a different way.
struct SnapshotErrorLocation {

  let file: StaticString
  let function: String
  let line: UInt

  static func errorOnThisLine(file: StaticString = #file,
                              function: String = #function,
                              line: UInt = #line) -> SnapshotErrorLocation {
    return SnapshotErrorLocation(file: file, function: function, line: line)
  }
}
