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
    case online(host: String)
    #if DEBUG
    case offline
    #endif
  }

  public init(apiMode: ApiMode, configuration: Configuration) {
    let bundle = Bundle.main
    let device = UIDevice.current
    let screen = UIScreen.main

    self.bundle = BundleManager(bundle: bundle)
    self.debug = DebugManager()
    self.device = DeviceManager(device: device, screen: screen)
    self.log = LogManager(bundle: self.bundle)
    self.userLocation = UserLocationManager()
    self.configuration = configuration

    let fs = FileSystem()
    let storageInner = StorageManager(fileSystem: fs, log: self.log)
    self.storage = CachedStorageManager(using: storageInner)

    switch apiMode {
    case .online(let host):
      let network = Network()
      self.api = Api(host: host,
                     network: network,
                     bundle: self.bundle,
                     device: self.device,
                     log: self.log)
    case .offline:
      self.api = OfflineApi(log: self.log)
    }
  }

  public init(api: ApiType,
              bundle: BundleManagerType,
              debug: DebugManagerType,
              device: DeviceManagerType,
              log: LogManagerType,
              storage: StorageManagerType,
              userLocation: UserLocationManagerType,
              configuration: Configuration) {
    self.api = api
    self.bundle = bundle
    self.debug = debug
    self.device = device
    self.log = log
    self.storage = storage
    self.userLocation = userLocation
    self.configuration = configuration
  }
}
