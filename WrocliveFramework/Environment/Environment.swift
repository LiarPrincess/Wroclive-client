// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public class Environment {

  public let api: ApiType
  public let bundle: BundleManagerType
  public let debug: DebugManagerType
  public let device: DeviceManagerType
  public let log: LogManagerType
  public let storage: StorageManagerType
  public let userLocation: UserLocationManagerType
  public let configuration: Configuration

  public enum ApiMode {
    case production
    #if DEBUG
    case debugOffline
    #endif
  }

  public init(apiMode: ApiMode) {
    let bundle = Bundle.main
    let device = UIDevice.current
    let screen = UIScreen.main

    self.bundle = BundleManager(bundle: bundle)
    self.debug = DebugManager()
    self.device = DeviceManager(device: device, screen: screen)
    self.log = LogManager(bundle: self.bundle)
    self.userLocation = UserLocationManager()
    self.configuration = Configuration()

    let fs = FileSystem()
    let storageInner = StorageManager(fileSystem: fs, log: self.log)
    self.storage = CachedStorageManager(using: storageInner)

    switch apiMode {
    case .production:
      let network = Network()
      self.api = Api(bundle: self.bundle,
                     device: self.device,
                     configuration: self.configuration,
                     network: network,
                     log: self.log)
    case .debugOffline:
      self.api = OfflineApi(log: self.log)
    }
  }
}
