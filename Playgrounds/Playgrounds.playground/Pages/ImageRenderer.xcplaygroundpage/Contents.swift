////: A UIKit based Playground for presenting user interface
//
//import UIKit
//import MapKit
//import SnapKit
//import PlaygroundSupport
//@testable import Radar_Framework
//
//// Environment
//let environment = Environment()
//AppEnvironment.push(environment)
//
//Managers.theme.applyColorScheme()
//Managers.theme.setColorScheme(tint: .black, tram: .black, bus: .black)
//
//// Rendering
//
//func saveView(_ view: UIView, as filename: String) {
//  let format = UIGraphicsImageRendererFormat()
//  format.prefersExtendedRange = false
//  format.opaque               = false
//  format.scale                = 3.0
//
//  let renderer = UIGraphicsImageRenderer(size: view.bounds.size, format: format)
//  let data = renderer.pngData { context in
//    view.layer.render(in: context.cgContext)
//  }
//
//  let url = playgroundSharedDataDirectory.appendingPathComponent(filename)
//  try! data.write(to: url)
//}
//
//// Main
//
//let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
////view.image = Images.mapBackground
////view.backgroundColor = UIColor.cyan
//
//func addPin(_ line: Line, _ origin: CGPoint, _ angle: Double) {
//  let vehicle           = Vehicle(vehicleId: "", line: line, latitude: 0.0, longitude: 0.0, angle: angle)
//  let vehicleAnnotation = VehicleAnnotation(from: vehicle)
//  let annotationView    = VehicleAnnotationView(vehicleAnnotation, reuseIdentifier: "")
//  annotationView.frame.origin = origin
//
//  view.addSubview(annotationView)
//}
//
////addPin(Line(name:   "4", type: .tram, subtype: .regular), CGPoint(x:  38.5, y: 340.0),  50.0)
////addPin(Line(name:   "4", type: .tram, subtype: .regular), CGPoint(x: 278.5, y: 283.0), 255.0)
////addPin(Line(name:   "6", type: .tram, subtype: .regular), CGPoint(x: 246.0, y:  93.5), 240.0)
////addPin(Line(name:   "6", type: .tram, subtype: .regular), CGPoint(x: 140.0, y: 212.5), 240.0)
////addPin(Line(name:   "7", type: .tram, subtype: .regular), CGPoint(x: 152.5, y: 307.5),  10.0)
////addPin(Line(name:   "7", type: .tram, subtype: .regular), CGPoint(x: 108.0, y: 375.5),  20.0)
////addPin(Line(name:  "14", type: .tram, subtype: .regular), CGPoint(x: 128.5, y: 93.0),  -10.0)
////addPin(Line(name:  "14", type: .tram, subtype: .regular), CGPoint(x: 115.5, y: 222.5), 240.0)
////addPin(Line(name:  "17", type: .tram, subtype: .regular), CGPoint(x: 205.0, y: 251.0), 190.0)
////addPin(Line(name:  "17", type: .tram, subtype: .regular), CGPoint(x: 199.5, y: 294.5),  10.0)
////addPin(Line(name:  "23", type: .tram, subtype: .regular), CGPoint(x: 222.0, y: 182.5),  20.0)
//addPin(Line(name:   "C", type:  .bus, subtype: .express), CGPoint(x: 144.5, y: 156.0),  50.0)
//addPin(Line(name: "104", type:  .bus, subtype: .regular), CGPoint(x:  33.0, y: 229.5), -40.0)
//addPin(Line(name: "106", type:  .bus, subtype: .regular), CGPoint(x: 109.0, y: 332.5), -35.0)
//addPin(Line(name: "109", type:  .bus, subtype: .regular), CGPoint(x:  16.5, y: 280.0), -100.0)
//addPin(Line(name: "125", type:  .bus, subtype: .regular), CGPoint(x: 220.0, y: 454.0), 240.0)
//addPin(Line(name: "142", type:  .bus, subtype: .regular), CGPoint(x: 102.0, y:  24.0), -15.0)
//addPin(Line(name: "142", type:  .bus, subtype: .regular), CGPoint(x:  87.5, y: 256.5),   0.0)
//addPin(Line(name: "146", type:  .bus, subtype: .regular), CGPoint(x: 149.5, y: 433.0),  10.0)
//
////PlaygroundPage.current.liveView = view
//
////let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
////
////let size = CGSize(width: 50, height: 50)
////view.image = StyleKit.drawCogwheelTemplateImage(size: size)
////view.tintColor = UIColor.black
////
////
////let trackingButton = MKUserTrackingButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
////trackingButton.mapView = MKMapView()
////trackingButton.tintColor = UIColor.black
//saveView(view, as: "image.png")
//print("done")

