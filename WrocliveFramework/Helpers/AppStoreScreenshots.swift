// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// This file contains overrides needed for creating AppStore screenshots.
//
// We are not using fastlane, because it is actually faster to do it by hand
// (we only need iPhone 8 Plus and iPhone 11 Pro Max).

// swiftlint:disable number_separator
// swiftformat:disable numberFormatting
// swiftlint:disable line_length
// swiftlint:disable closure_body_length
// swiftlint:disable file_length

import MapKit

private enum CurrentScreenshot {
  // They use the same data
  case mapOrBookmarks
  case night
}

internal enum AppStoreScreenshots {
  /// Change this to select data preset
  private static let current = CurrentScreenshot.mapOrBookmarks
}

// MARK: - 1. MainViewController

// 1. Add this override:
// override public var prefersStatusBarHidden: Bool {
//   return true
// }

extension AppStoreScreenshots {

  // 2. Call this at the end of 'viewDidLoad':
  internal static func viewDidLoad(main: MainViewController) {
    assert(
      main.prefersStatusBarHidden,
      "'prefersStatusBarHidden' override was not added"
    )

    main.map.mapView.showsTraffic = false
    main.map.mapView.showsUserLocation = false

    let mapRadius: CLLocationDistance
    switch Self.current {
    case .mapOrBookmarks: mapRadius = CLLocationDistance(1_500.0)
    case .night: mapRadius = CLLocationDistance(3_000.0)
    }

    let mapCenter = MapViewController.Constants.Default.center
    main.map.setCenter(location: mapCenter, radius: mapRadius, animated: false)

    switch Self.current {
    case .mapOrBookmarks:
      break
    case .night:
      Self.enableDarkMode(main: main)
    }
  }

  private static func enableDarkMode(main: MainViewController) {
    if #available(iOS 12.0, *) {
      let style = ColorScheme.blurStyle(for: .dark)
      main.toolbar.effect = UIBlurEffect(style: style)

      let old = main.map.traitCollection
      let dark = UITraitCollection(userInterfaceStyle: .dark)
      let new = UITraitCollection(traitsFrom: [old, dark])
      main.setOverrideTraitCollection(new, forChild: main.map)
    }
  }
}

// MARK: - 2. StorageManager

extension AppStoreScreenshots {

  internal static let bookmarks: [Bookmark] = {
    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram3 = Line(name: "3", type: .tram, subtype: .regular)
    let tram4 = Line(name: "4", type: .tram, subtype: .regular)
    let tram5 = Line(name: "5", type: .tram, subtype: .regular)
    let busA = Line(name: "A", type: .bus, subtype: .express)
    let busC = Line(name: "C", type: .bus, subtype: .express)
    let busD = Line(name: "D", type: .bus, subtype: .express)
    let tram0L = Line(name: "0L", type: .tram, subtype: .regular)
    let tram0P = Line(name: "0P", type: .tram, subtype: .regular)
    let tram10 = Line(name: "10", type: .tram, subtype: .regular)
    let tram11 = Line(name: "11", type: .tram, subtype: .regular)
    let tram14 = Line(name: "14", type: .tram, subtype: .regular)
    let tram20 = Line(name: "20", type: .tram, subtype: .regular)
    let tram24 = Line(name: "24", type: .tram, subtype: .regular)
    let tram31 = Line(name: "31", type: .tram, subtype: .regular)
    let tram32 = Line(name: "32", type: .tram, subtype: .regular)
    let tram33 = Line(name: "33", type: .tram, subtype: .regular)
    let bus107 = Line(name: "107", type: .bus, subtype: .regular)
    let bus125 = Line(name: "125", type: .bus, subtype: .regular)
    let bus126 = Line(name: "126", type: .bus, subtype: .regular)
    let bus134 = Line(name: "134", type: .bus, subtype: .regular)
    let bus136 = Line(name: "136", type: .bus, subtype: .regular)
    let bus145 = Line(name: "145", type: .bus, subtype: .regular)
    let bus146 = Line(name: "146", type: .bus, subtype: .regular)
    let bus149 = Line(name: "149", type: .bus, subtype: .regular)
    let bus241 = Line(name: "241", type: .bus, subtype: .night)
    let bus246 = Line(name: "246", type: .bus, subtype: .night)
    let bus248 = Line(name: "248", type: .bus, subtype: .night)
    let bus251 = Line(name: "251", type: .bus, subtype: .night)
    let bus257 = Line(name: "257", type: .bus, subtype: .night)
    let bus319 = Line(name: "319", type: .bus, subtype: .regular)
    let bus325 = Line(name: "325", type: .bus, subtype: .regular)

    let locale = Locale.current
    let isPL = locale.identifier.lowercased().starts(with: "pl")

    let university = Bookmark(
      name: "📚 \(isPL ? "Uczelnia" : "University")",
      lines: [
        tram0L, tram0P, tram1, tram10, tram33,
        busA, busC, busD, bus145, bus146, bus149
      ]
    )

    let work = Bookmark(
      name: "🏢 \(isPL ? "Praca" : "Work")",
      lines: [
        tram3, tram4, tram10, tram20, tram31, tram32, tram33,
        bus319, bus126, bus134, bus136
      ]
    )

    let city = Bookmark(
      name: "🍦 \(isPL ? "Miasto" : "City")",
      lines: [
        tram4, tram5, tram11, tram14, tram20, tram24,
        busA, busD, bus107, bus125, bus319, bus325
      ]
    )

    let night = Bookmark(
      name: "🌙 \(isPL ? "Nocne" : "Night")",
      lines: [bus241, bus246, bus248, bus251, bus257]
    )

    return [university, work, city, night]
  }()
}

// MARK: - 3. Api response

extension AppStoreScreenshots {

  internal static var vehicles: [Vehicle] {
    switch self.current {
    case .mapOrBookmarks:
      return Self.dailyVehicles
    case .night:
      return Self.nightVehicles
    }
  }

  /// Vehicles for `map` screenshot.
  private static let dailyVehicles: [Vehicle] = {
    let line4 = Line(name: "4", type: .tram, subtype: .regular)
    let line6 = Line(name: "6", type: .tram, subtype: .regular)
    let line16 = Line(name: "16", type: .tram, subtype: .regular)
    let line20 = Line(name: "20", type: .tram, subtype: .regular)
    let line101 = Line(name: "101", type: .bus, subtype: .regular)
    let line102 = Line(name: "102", type: .bus, subtype: .regular)
    let line125 = Line(name: "125", type: .bus, subtype: .regular)
    let line136 = Line(name: "136", type: .bus, subtype: .regular)
    let line146 = Line(name: "146", type: .bus, subtype: .regular)
    let line612 = Line(name: "612", type: .bus, subtype: .suburban)
    let line701 = Line(name: "701", type: .bus, subtype: .temporary)
    let line714 = Line(name: "714", type: .bus, subtype: .temporary)
    let lineA = Line(name: "A", type: .bus, subtype: .express)

    return [
      Vehicle(id: "16245155", line: line20, latitude: 51.11504, longitude: 17.002327, angle: 139.04539764300523),
      Vehicle(id: "16245055", line: line20, latitude: 51.140972, longitude: 16.912336, angle: 101.82972374936128),
      Vehicle(id: "16244470", line: line20, latitude: 51.09403, longitude: 17.02096, angle: -144.90427013151816),
      Vehicle(id: "16245189", line: line20, latitude: 51.092384, longitude: 16.977676, angle: 15.773915996918163),
      Vehicle(id: "16244763", line: line20, latitude: 51.142914, longitude: 16.897179, angle: -78.97396181751361),
      Vehicle(id: "16245173", line: line20, latitude: 51.12448, longitude: 16.985865, angle: 114.52839136432385),
      Vehicle(id: "16243875", line: line20, latitude: 51.108593, longitude: 17.027336, angle: 112.2424013208041),
      Vehicle(id: "16244941", line: line20, latitude: 51.117695, longitude: 16.99922, angle: -31.70847902089531),
      Vehicle(id: "16244802", line: line20, latitude: 51.0841, longitude: 16.972288, angle: 0.0),
      Vehicle(id: "16244511", line: line20, latitude: 51.0907, longitude: 17.017105, angle: 36.60540762776509),
      Vehicle(id: "16244480", line: line20, latitude: 51.09769, longitude: 17.025345, angle: -145.27787975960052),
      Vehicle(id: "16245017", line: line20, latitude: 51.138206, longitude: 16.93242, angle: -82.85760577272202),
      Vehicle(id: "16228137", line: line136, latitude: 51.086555, longitude: 17.012175, angle: -69.40890026991673),
      Vehicle(id: "16228046", line: line136, latitude: 51.094055, longitude: 16.98073, angle: -31.112360017601247),
      Vehicle(id: "16228034", line: line136, latitude: 51.121773, longitude: 16.967573, angle: -77.88106019186165),
      Vehicle(id: "16228120", line: line136, latitude: 51.07684, longitude: 17.04874, angle: 93.78957536757503),
      Vehicle(id: "16228131", line: line136, latitude: 51.086, longitude: 17.012943, angle: 106.52554309424454),
      Vehicle(id: "16228000", line: line136, latitude: 51.137455, longitude: 16.968988, angle: 0.0),
      Vehicle(id: "16228069", line: line136, latitude: 51.077114, longitude: 17.040081, angle: -86.87173683485042),
      Vehicle(id: "16228015", line: line136, latitude: 51.10233, longitude: 16.97212, angle: 161.7584101427434),
      Vehicle(id: "16229647", line: line701, latitude: 51.102585, longitude: 17.116024, angle: 0.0),
      Vehicle(id: "16229766", line: line701, latitude: 51.106995, longitude: 17.07308, angle: 128.7532384254821),
      Vehicle(id: "16229815", line: line701, latitude: 51.105785, longitude: 17.07685, angle: -61.88612931993907),
      Vehicle(id: "16229871", line: line701, latitude: 51.110775, longitude: 17.06215, angle: -58.62701084465624),
      Vehicle(id: "16229706", line: line701, latitude: 51.100975, longitude: 17.109346, angle: 97.28152861197407),
      Vehicle(id: "16229589", line: line701, latitude: 51.101006, longitude: 17.115356, angle: -110.75300697071873),
      Vehicle(id: "16161434", line: line714, latitude: 51.137672, longitude: 16.993505, angle: -69.01001637847298),
      Vehicle(id: "16161483", line: line714, latitude: 51.141533, longitude: 16.991594, angle: 0.0),
      Vehicle(id: "16161596", line: line714, latitude: 51.124107, longitude: 17.033167, angle: 0.0),
      Vehicle(id: "16161541", line: line714, latitude: 51.1345, longitude: 17.01138, angle: 100.39941682088511),
      Vehicle(id: "16161697", line: line714, latitude: 51.13316, longitude: 17.02639, angle: -77.76282212910507),
      Vehicle(id: "16161652", line: line714, latitude: 51.12549, longitude: 17.02826, angle: 166.3872909047859),
      Vehicle(id: "16114749", line: line101, latitude: 51.163845, longitude: 16.896795, angle: 31.005642470011253),
      Vehicle(id: "16114699", line: line101, latitude: 51.14518, longitude: 16.94691, angle: 107.76989123012561),
      Vehicle(id: "16114667", line: line101, latitude: 51.145176, longitude: 16.87282, angle: -89.99970135405187),
      Vehicle(id: "16114736", line: line101, latitude: 51.144615, longitude: 16.87111, angle: 0.0),
      Vehicle(id: "16114715", line: line101, latitude: 51.157753, longitude: 16.922749, angle: -9.645844900068028),
      Vehicle(id: "16224566", line: line102, latitude: 51.11307, longitude: 17.020815, angle: 0.0),
      Vehicle(id: "16224661", line: line102, latitude: 51.111923, longitude: 17.021212, angle: 121.54716555476637),
      Vehicle(id: "16224607", line: line102, latitude: 51.142887, longitude: 16.906178, angle: 15.255299355320403),
      Vehicle(id: "16224632", line: line102, latitude: 51.152973, longitude: 16.940063, angle: -38.968781192510335),
      Vehicle(id: "16224593", line: line102, latitude: 51.135075, longitude: 16.968857, angle: 133.55246081988355),
      Vehicle(id: "16224552", line: line102, latitude: 51.12549, longitude: 16.983656, angle: -56.2319180082452),
      Vehicle(id: "16224579", line: line102, latitude: 51.15954, longitude: 16.910889, angle: 110.83308697446319),
      Vehicle(id: "16244232", line: line4, latitude: 51.08366, longitude: 16.971703, angle: 0.0),
      Vehicle(id: "16245417", line: line4, latitude: 51.10124, longitude: 17.008282, angle: -108.7435082342256),
      Vehicle(id: "16245377", line: line4, latitude: 51.084515, longitude: 16.972013, angle: 12.340593452074359),
      Vehicle(id: "16245526", line: line4, latitude: 51.10768, longitude: 17.039722, angle: -77.49705606793373),
      Vehicle(id: "16245467", line: line4, latitude: 51.107372, longitude: 17.042105, angle: 99.2511443415201),
      Vehicle(id: "16244821", line: line4, latitude: 51.105797, longitude: 17.07704, angle: 118.89740427739741),
      Vehicle(id: "16245507", line: line4, latitude: 51.102184, longitude: 17.012741, angle: 73.60197591814176),
      Vehicle(id: "16245445", line: line4, latitude: 51.110332, longitude: 17.056149, angle: 70.46450495423676),
      Vehicle(id: "16245485", line: line4, latitude: 51.107033, longitude: 17.073492, angle: -60.21523270658872),
      Vehicle(id: "16245566", line: line6, latitude: 51.088585, longitude: 17.014544, angle: -143.03006318812334),
      Vehicle(id: "16245585", line: line6, latitude: 51.105186, longitude: 17.02816, angle: 128.07870275266316),
      Vehicle(id: "16245699", line: line6, latitude: 51.086105, longitude: 17.011805, angle: 22.80561307365201),
      Vehicle(id: "16245593", line: line6, latitude: 51.123753, longitude: 17.044672, angle: 16.62135456715521),
      Vehicle(id: "16245639", line: line6, latitude: 51.127632, longitude: 17.102455, angle: 142.3119290364325),
      Vehicle(id: "16245619", line: line6, latitude: 51.123646, longitude: 17.044636, angle: -162.71355036324962),
      Vehicle(id: "16245682", line: line6, latitude: 51.107014, longitude: 17.03335, angle: 6.080408091656182),
      Vehicle(id: "16245661", line: line6, latitude: 51.117214, longitude: 17.041437, angle: 129.66171787506096),
      Vehicle(id: "16230042", line: lineA, latitude: 51.08978, longitude: 16.976667, angle: -164.82619668166825),
      Vehicle(id: "16230023", line: lineA, latitude: 51.08144, longitude: 16.968155, angle: 36.97540306017618),
      Vehicle(id: "16230086", line: lineA, latitude: 51.098812, longitude: 17.026451, angle: -142.5891091831154),
      Vehicle(id: "16229989", line: lineA, latitude: 51.137413, longitude: 17.053001, angle: -50.01738009752728),
      Vehicle(id: "16230056", line: lineA, latitude: 51.0951, longitude: 16.989338, angle: -72.8002815920043),
      Vehicle(id: "16229960", line: lineA, latitude: 51.1417, longitude: 17.064697, angle: 0.0),
      Vehicle(id: "16230003", line: lineA, latitude: 51.093464, longitude: 17.008877, angle: 88.32187680576294),
      Vehicle(id: "16229976", line: lineA, latitude: 51.10113, longitude: 17.040266, angle: 107.7784316323507),
      Vehicle(id: "16246700", line: line16, latitude: 51.07992, longitude: 17.062654, angle: 160.12151893103533),
      Vehicle(id: "16246393", line: line16, latitude: 51.086605, longitude: 17.046623, angle: -53.60310648276612),
      Vehicle(id: "16246717", line: line16, latitude: 51.11027, longitude: 17.055809, angle: 67.93598302041903),
      Vehicle(id: "16246606", line: line16, latitude: 51.11149, longitude: 17.059797, angle: -112.57486029437985),
      Vehicle(id: "16246586", line: line16, latitude: 51.09183, longitude: 17.04362, angle: 161.03621827355994),
      Vehicle(id: "16226930", line: line125, latitude: 51.09033, longitude: 16.976862, angle: -163.75821830447848),
      Vehicle(id: "16227002", line: line125, latitude: 51.09383, longitude: 16.998674, angle: -80.90615300046392),
      Vehicle(id: "16227023", line: line125, latitude: 51.080055, longitude: 16.994595, angle: -113.10735312673904),
      Vehicle(id: "16227040", line: line125, latitude: 51.093513, longitude: 17.01952, angle: 113.06330010248371),
      Vehicle(id: "16227013", line: line125, latitude: 51.085007, longitude: 17.048105, angle: 134.85505390388437),
      Vehicle(id: "16226979", line: line125, latitude: 51.058968, longitude: 17.086761, angle: 0.0),
      Vehicle(id: "16227028", line: line125, latitude: 51.08538, longitude: 17.048052, angle: -53.08005327865169),
      Vehicle(id: "16227031", line: line125, latitude: 51.077763, longitude: 16.963995, angle: -41.89323916051717),
      Vehicle(id: "16225667", line: line612, latitude: 51.09939, longitude: 17.035099, angle: 0.0),
      Vehicle(id: "16225743", line: line612, latitude: 51.056633, longitude: 17.022263, angle: 18.046254719214403),
      Vehicle(id: "16225779", line: line612, latitude: 51.07517, longitude: 17.007828, angle: -38.2189988855406),
      Vehicle(id: "16228843", line: line146, latitude: 51.08573, longitude: 17.035406, angle: 2.8449630914350337),
      Vehicle(id: "16228796", line: line146, latitude: 51.10539, longitude: 17.077837, angle: 119.32878873430809),
      Vehicle(id: "16228851", line: line146, latitude: 51.09706, longitude: 17.032225, angle: -150.83190711880104),
      Vehicle(id: "16228791", line: line146, latitude: 51.10998, longitude: 17.054552, angle: 69.18669970198107),
      Vehicle(id: "16228777", line: line146, latitude: 51.10885, longitude: 17.049273, angle: -113.47933605210517)
    ]
  }()

  /// Vehicles for `night` screenshot.
  private static let nightVehicles: [Vehicle] = {
    let line4 = Line(name: "4", type: .tram, subtype: .regular)
    let line101 = Line(name: "101", type: .bus, subtype: .regular)
    let line125 = Line(name: "125", type: .bus, subtype: .regular)
    let line136 = Line(name: "136", type: .bus, subtype: .regular)
    let line206 = Line(name: "206", type: .bus, subtype: .night)
    let line240 = Line(name: "240", type: .bus, subtype: .night)
    let line241 = Line(name: "241", type: .bus, subtype: .night)
    let line242 = Line(name: "242", type: .bus, subtype: .night)
    let line243 = Line(name: "243", type: .bus, subtype: .night)
    let line245 = Line(name: "245", type: .bus, subtype: .night)
    let line246 = Line(name: "246", type: .bus, subtype: .night)
    let line247 = Line(name: "247", type: .bus, subtype: .night)
    let line249 = Line(name: "249", type: .bus, subtype: .night)
    let line250 = Line(name: "250", type: .bus, subtype: .night)
    let line251 = Line(name: "251", type: .bus, subtype: .night)
    let line253 = Line(name: "253", type: .bus, subtype: .night)
    let line255 = Line(name: "255", type: .bus, subtype: .night)
    let line257 = Line(name: "257", type: .bus, subtype: .night)
    let line259 = Line(name: "259", type: .bus, subtype: .night)
    let line701 = Line(name: "701", type: .bus, subtype: .temporary)

    return [
      Vehicle(id: "16213986", line: line4, latitude: 51.125275, longitude: 17.041441, angle: -20.244323598245387),
      Vehicle(id: "16213424", line: line4, latitude: 51.089363, longitude: 17.001657, angle: 105.07277266028211),
      Vehicle(id: "16213941", line: line4, latitude: 51.12538, longitude: 17.04098, angle: -96.39005346064505),
      Vehicle(id: "16239018", line: line243, latitude: 51.11326, longitude: 17.007788, angle: -85.6792830595578),
      Vehicle(id: "16239025", line: line243, latitude: 51.105774, longitude: 17.04705, angle: 114.32600165449958),
      Vehicle(id: "16239071", line: line246, latitude: 51.177555, longitude: 16.998945, angle: 4.761273817508481),
      Vehicle(id: "16239086", line: line246, latitude: 51.107765, longitude: 17.03993, angle: -82.57190147430799),
      Vehicle(id: "16238990", line: line241, latitude: 51.119408, longitude: 16.952063, angle: 0.0),
      Vehicle(id: "16237845", line: line241, latitude: 51.09655, longitude: 16.95654, angle: -79.57080905681369),
      Vehicle(id: "16238960", line: line241, latitude: 51.15666, longitude: 17.123842, angle: -62.292469980489614),
      Vehicle(id: "16237092", line: line241, latitude: 51.107677, longitude: 17.04675, angle: 85.12637783571734),
      Vehicle(id: "16239178", line: line251, latitude: 51.143215, longitude: 17.13897, angle: 86.9070464481332),
      Vehicle(id: "16239604", line: line251, latitude: 51.10348, longitude: 17.026638, angle: 104.81820141603839),
      Vehicle(id: "16239102", line: line247, latitude: 51.06806, longitude: 16.970207, angle: -137.16492007660725),
      Vehicle(id: "16239355", line: line701, latitude: 51.10933, longitude: 17.066246, angle: -62.77724670359157),
      Vehicle(id: "16239454", line: line701, latitude: 51.112167, longitude: 17.06316, angle: 0.0),
      Vehicle(id: "16239404", line: line701, latitude: 51.10305, longitude: 17.09609, angle: 100.2876861882429),
      Vehicle(id: "16239543", line: line701, latitude: 51.102375, longitude: 17.115942, angle: 0.0),
      Vehicle(id: "16239222", line: line255, latitude: 51.077087, longitude: 17.049438, angle: 0.0),
      Vehicle(id: "16239233", line: line255, latitude: 51.1141, longitude: 17.103796, angle: 0.0),
      Vehicle(id: "16239247", line: line257, latitude: 51.13719, longitude: 16.994444, angle: 134.46879520212065),
      Vehicle(id: "16239582", line: line257, latitude: 51.12388, longitude: 17.029541, angle: -22.00753515186784),
      Vehicle(id: "16239255", line: line257, latitude: 51.087543, longitude: 17.007309, angle: 116.45302530692902),
      Vehicle(id: "16239203", line: line253, latitude: 51.138115, longitude: 16.898708, angle: 105.81436567086212),
      Vehicle(id: "16238947", line: line240, latitude: 51.09992, longitude: 17.036015, angle: -72.09809063721525),
      Vehicle(id: "16239263", line: line259, latitude: 51.11588, longitude: 17.060541, angle: 93.45646397597307),
      Vehicle(id: "16139606", line: line101, latitude: 51.161453, longitude: 16.89445, angle: -150.50904095875387),
      Vehicle(id: "16139580", line: line101, latitude: 51.14402, longitude: 16.949741, angle: 112.51815254757025),
      Vehicle(id: "16239166", line: line250, latitude: 51.112354, longitude: 17.06071, angle: 0.0),
      Vehicle(id: "16237154", line: line250, latitude: 51.12418, longitude: 17.044888, angle: -119.8176765750901),
      Vehicle(id: "16238504", line: line245, latitude: 51.116234, longitude: 17.011808, angle: -69.15027553436869),
      Vehicle(id: "16239063", line: line245, latitude: 51.078587, longitude: 17.063972, angle: -89.45900699484838),
      Vehicle(id: "16237651", line: line125, latitude: 51.086185, longitude: 17.046696, angle: 164.34133235466106),
      Vehicle(id: "16239140", line: line249, latitude: 51.112465, longitude: 16.97839, angle: -88.90548437492458),
      Vehicle(id: "16239240", line: line249, latitude: 51.076965, longitude: 17.042072, angle: 92.3054590262019),
      Vehicle(id: "16238939", line: line206, latitude: 51.09972, longitude: 17.035442, angle: 45.67279674887925),
      Vehicle(id: "16239008", line: line242, latitude: 1040.4746, longitude: 4681.849, angle: -168.297864972647),
      Vehicle(id: "16239196", line: line136, latitude: 51.0898, longitude: 17.000072, angle: -71.99937932733837)
    ]
  }()
}
