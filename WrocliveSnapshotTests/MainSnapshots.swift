// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import MapKit
import XCTest
import ReSwift
import SnapKit
import SnapshotTesting
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable implicitly_unwrapped_optional
// swiftformat:disable numberFormatting

class MainSnapshots: XCTestCase, ReduxTestCase, EnvironmentTestCase, SnapshotTestCase {

  var store: Store<AppState>!
  var dispatchedActions: [Action]!
  var environment: Environment!

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpEnvironment()
  }

  // MARK: - Tests

  func test_noVehicles() {
    self.onAllDevices { assertSnapshot in
      self.setMapType(type: .standard)
      self.setVehicles(state: .inProgress)
      self.denyLocationAuthorizationSoThatCenterStaysOnDefault()

      let viewModel = MainViewModel(store: self.store,
                                    environment: self.environment,
                                    delegate: nil)

      let view = MainViewController(viewModel: viewModel)
      self.renderPinsOnSeparateLayer(main: view)

      assertSnapshot(view, .errorOnThisLine())
    }
  }

  func test_vehicles() {
    self.onAllDevices { assertSnapshot in
      self.setMapType(type: .standard)
      self.setVehicles(vehicles: self.vehicles)
      self.denyLocationAuthorizationSoThatCenterStaysOnDefault()

      let viewModel = MainViewModel(store: self.store,
                                    environment: self.environment,
                                    delegate: nil)

      let view = MainViewController(viewModel: viewModel)
      self.renderPinsOnSeparateLayer(main: view)

      assertSnapshot(view, .errorOnThisLine())
    }
  }

  func test_dark() {
    self.inDarkMode { assertSnapshot in
      self.setMapType(type: .standard)
      self.setVehicles(vehicles: self.vehicles)
      self.denyLocationAuthorizationSoThatCenterStaysOnDefault()

      let viewModel = MainViewModel(store: self.store,
                                    environment: self.environment,
                                    delegate: nil)

      let view = MainViewController(viewModel: viewModel)
      self.renderPinsOnSeparateLayer(main: view)

      assertSnapshot(view, .errorOnThisLine())
    }
  }

  // MARK: - Helpers

  private func setVehicles(state: AppState.ApiResponseState<[Vehicle]>) {
    self.setState { $0.getVehicleLocationsResponse = state }
  }

  private func setVehicles(vehicles: [Vehicle]) {
    self.setVehicles(state: .data(vehicles))
  }

  private func setMapType(type: MapType) {
    self.setState { $0.mapType = type }
  }

  private func denyLocationAuthorizationSoThatCenterStaysOnDefault() {
    self.setState { $0.userLocationAuthorization = .denied }
  }

  /// Since we can't properly render the whole map during snapshot testing
  /// we need a different way to render pins.
  /// This method will add an additional view on top of the map with just pins.
  private func renderPinsOnSeparateLayer(main: MainViewController) {
    // We need to layout to be able to call 'mapView.convert'
    main.view.setNeedsLayout()
    main.view.layoutIfNeeded()

    let mapView = main.map.mapView
    let fakeMap = self.addFakeMapView(to: main)

    var annotations = mapView.annotations.compactMap { $0 as? VehicleAnnotation }
    annotations.sort { lhs, rhs in lhs.vehicleId < rhs.vehicleId }

    for annotation in annotations {
      guard let pin = mapView.view(for: annotation) as? VehicleAnnotationView else {
        continue
      }

      let copy = VehicleAnnotationView(annotation: annotation, reuseIdentifier: nil)
      let origin = mapView.convert(annotation.coordinate, toPointTo: mapView)
      copy.frame = CGRect(origin: origin, size: pin.frame.size)
      fakeMap.addSubview(copy)
    }
  }

  private func addFakeMapView(to main: MainViewController) -> UIView {
    let view = UIView()

    let backgroundColor = UIColor(light: #colorLiteral(red: 0.9761956334, green: 0.9593092799, blue: 0.9283472896, alpha: 1), dark: #colorLiteral(red: 0.1676809788, green: 0.1772463322, blue: 0.1819401383, alpha: 1))
    view.backgroundColor = backgroundColor

    addFakeMapGrid(main: main, map: view)
    addFakeLegalLabel(main: main)

    main.map.view.addSubview(view)
    view.snp.makeConstraints { $0.edges.equalToSuperview() }

    return view
  }

  private func addFakeMapGrid(main: MainViewController, map: UIView) {
    let gridSize: CGFloat = 68
    let path = UIBezierPath()
    let frame = main.view.frame

    var xPosition = gridSize / 2
    while xPosition < frame.width {
      path.move(to: CGPoint(x: xPosition, y: 0.0))
      path.addLine(to: CGPoint(x: xPosition, y: frame.height))
      xPosition += gridSize
    }

    var yPosition = gridSize / 2
    while yPosition < frame.height {
      path.move(to: CGPoint(x: 0.0, y: yPosition))
      path.addLine(to: CGPoint(x: frame.width, y: yPosition))
      yPosition += gridSize
    }

    path.close()

    let pathLayer = CAShapeLayer()
    pathLayer.path = path.cgPath
    pathLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
    map.layer.addSublayer(pathLayer)
  }

  private func addFakeLegalLabel(main: MainViewController) {
    let label = UILabel()

    label.attributedText = NSAttributedString(string: "Legal", attributes: [
      NSAttributedString.Key.foregroundColor: UIColor.gray,
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9.0, weight: .semibold),
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ])

    main.view.addSubview(label)
    label.snp.makeConstraints { make in
      make.bottom.equalTo(main.toolbar.snp.top).offset(-10.0)
      make.right.equalToSuperview().offset(-12.0)
    }
  }

  // MARK: - Test data

  // swiftlint:disable number_separator line_length closure_body_length

  /// Use following code to print api response:
  /// ```
  ///     print("==============================")
  /// for (index, vehicle) in result.enumerated() {
  ///   print("let line\(vehicle.line.name) = \(vehicle.line)")
  ///   // swiftlint:disable:next line_length
  ///   print("let vehicle\(index) = Vehicle(id: \"\(index)\", line: line\(vehicle.line.name), latitude: \(vehicle.latitude), longitude: \(vehicle.longitude), angle: \(vehicle.angle))")
  /// }
  /// ```
  private let vehicles: [Vehicle] = {
    let line4 = Line(name: "4", type: .tram, subtype: .regular)
    let line20 = Line(name: "20", type: .tram, subtype: .regular)
    let lineA = Line(name: "A", type: .bus, subtype: .express)
    let line125 = Line(name: "125", type: .bus, subtype: .regular)
    let line612 = Line(name: "612", type: .bus, subtype: .suburban)
    let line701 = Line(name: "701", type: .bus, subtype: .temporary)
    let line714 = Line(name: "714", type: .bus, subtype: .temporary)

    // Vehicle at default map center.
    let centerLine = Line(name: "❤️", type: .bus, subtype: .suburban)
    let center = Vehicle(id: "Center", line: centerLine, latitude: 51.109524, longitude: 17.032564, angle: 0.0)

    // Vehicle at default Apple-specified map center.
    let appleLine = Line(name: "🍎", type: .bus, subtype: .suburban)
    let appleCenter = Vehicle(id: "Apple", line: appleLine, latitude: 37.334599999999995, longitude: -122.00919999999999, angle: 0.0)

    return [
      center,
      appleCenter,
      Vehicle(id: "0", line: line701, latitude: 51.11017, longitude: 17.063921, angle: -56.046990574206745),
      Vehicle(id: "1", line: line701, latitude: 51.10426, longitude: 17.084019, angle: -94.49158887734279),
      Vehicle(id: "10", line: lineA, latitude: 51.076538, longitude: 16.967363, angle: -79.58853631502052),
      Vehicle(id: "11", line: lineA, latitude: 51.09437, longitude: 17.015734, angle: -98.05805288036703),
      Vehicle(id: "12", line: lineA, latitude: 51.091938, longitude: 16.984745, angle: -99.4124436663322),
      Vehicle(id: "13", line: lineA, latitude: 51.118073, longitude: 17.05142, angle: 172.08689436518682),
      Vehicle(id: "14", line: line20, latitude: 51.127373, longitude: 16.978521, angle: 115.06734345714551),
      Vehicle(id: "15", line: line20, latitude: 51.12157, longitude: 16.993238, angle: -51.20492126224701),
      Vehicle(id: "16", line: line20, latitude: 51.089413, longitude: 17.001583, angle: -66.84083740129091),
      Vehicle(id: "17", line: line20, latitude: 51.112503, longitude: 17.01814, angle: 97.24126028920932),
      Vehicle(id: "18", line: line20, latitude: 51.088173, longitude: 17.00607, angle: 118.04815120387855),
      Vehicle(id: "19", line: line20, latitude: 51.089287, longitude: 16.976578, angle: 22.134087380410733),
      Vehicle(id: "2", line: line701, latitude: 51.112213, longitude: 17.063124, angle: 0.0),
      Vehicle(id: "20", line: line20, latitude: 51.089325, longitude: 16.976576, angle: -172.86010571219936),
      Vehicle(id: "21", line: line20, latitude: 51.12926, longitude: 16.972136, angle: -64.54712444261008),
      Vehicle(id: "22", line: line20, latitude: 51.104652, longitude: 17.029488, angle: -37.879117776408975),
      Vehicle(id: "23", line: line20, latitude: 51.10211, longitude: 17.029724, angle: -156.00807695090896),
      Vehicle(id: "24", line: line20, latitude: 51.141735, longitude: 16.906338, angle: 102.34692659047073),
      Vehicle(id: "25", line: line20, latitude: 51.144627, longitude: 16.871725, angle: 0.0),
      Vehicle(id: "26", line: line20, latitude: 51.134987, longitude: 16.953218, angle: -48.174582995997184),
      Vehicle(id: "27", line: line714, latitude: 51.135975, longitude: 16.999275, angle: -80.23851334381169),
      Vehicle(id: "28", line: line714, latitude: 51.141563, longitude: 16.991518, angle: 0.0),
      Vehicle(id: "29", line: line714, latitude: 51.131294, longitude: 17.027874, angle: 175.43789522011946),
      Vehicle(id: "3", line: line701, latitude: 51.102608, longitude: 17.115976, angle: 0.0),
      Vehicle(id: "30", line: line714, latitude: 51.122746, longitude: 17.030582, angle: -105.49327644390837),
      Vehicle(id: "31", line: line714, latitude: 51.124126, longitude: 17.033346, angle: 0.0),
      Vehicle(id: "32", line: line714, latitude: 51.137135, longitude: 16.994463, angle: 157.38353146843428),
      Vehicle(id: "33", line: line4, latitude: 51.107388, longitude: 17.041935, angle: 100.63133695996362),
      Vehicle(id: "34", line: line4, latitude: 51.10556, longitude: 17.07771, angle: 0.0),
      Vehicle(id: "35", line: line4, latitude: 51.09983, longitude: 17.002146, angle: 69.8777997316538),
      Vehicle(id: "36", line: line4, latitude: 51.08428, longitude: 16.972033, angle: 0.0),
      Vehicle(id: "37", line: line4, latitude: 51.106346, longitude: 17.024323, angle: 19.917337166173184),
      Vehicle(id: "38", line: line4, latitude: 51.101147, longitude: 17.00734, angle: -108.86531496281498),
      Vehicle(id: "39", line: line125, latitude: 51.07648, longitude: 16.976734, angle: 81.2057792191863),
      Vehicle(id: "4", line: line701, latitude: 51.103127, longitude: 17.095871, angle: 101.29848532079768),
      Vehicle(id: "40", line: line125, latitude: 51.09368, longitude: 16.986876, angle: 13.113215037895088),
      Vehicle(id: "41", line: line125, latitude: 51.082848, longitude: 17.050323, angle: 132.83808305544153),
      Vehicle(id: "42", line: line125, latitude: 51.09836, longitude: 17.030151, angle: -71.36143298265347),
      Vehicle(id: "43", line: line125, latitude: 51.0915, longitude: 17.043737, angle: 157.24016417560256),
      Vehicle(id: "44", line: line125, latitude: 51.077126, longitude: 16.964827, angle: -68.84886472699321),
      Vehicle(id: "45", line: line125, latitude: 51.05908, longitude: 17.086449, angle: -58.22853268156274),
      Vehicle(id: "46", line: line125, latitude: 51.08317, longitude: 17.050154, angle: -87.08506880255123),
      Vehicle(id: "47", line: line612, latitude: 51.080746, longitude: 17.034382, angle: -178.7728698657142),
      Vehicle(id: "48", line: line612, latitude: 51.077568, longitude: 17.033924, angle: 14.336015528484154),
      Vehicle(id: "5", line: lineA, latitude: 51.11437, longitude: 17.050707, angle: 13.163401880827564),
      Vehicle(id: "6", line: lineA, latitude: 51.114388, longitude: 17.050396, angle: -164.54297184529275),
      Vehicle(id: "7", line: lineA, latitude: 51.093594, longitude: 17.008554, angle: 45.54097966341101),
      Vehicle(id: "8", line: lineA, latitude: 51.076263, longitude: 16.971794, angle: -97.02047031619725),
      Vehicle(id: "9", line: lineA, latitude: 51.13204, longitude: 17.06321, angle: 133.6973993452733)
    ]
  }()

  // swiftlint:enable number_separator line_length closure_body_length
}
