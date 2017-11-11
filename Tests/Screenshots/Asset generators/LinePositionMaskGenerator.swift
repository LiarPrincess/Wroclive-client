//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

/// This class can be used to generate mask for color scheme test view for trams/busses
/// To use it:
/// 1. Add this file to 'Radar' target (TEMPORARY)
/// 2. Create instance of LinePositionMaskGenerator
/// 3. Use 'generate(:)' method on root view controller
class LinePositionMaskGenerator {

  static func createMaskImages() {
    let imageSize  = CGRect(x: 0, y: 0, width: 320, height: 568)
    let imageScale = CGFloat(3.0)

    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!

    print("Starting image generation...")
    print("Generated images will be saved at: \(documentsDirectory.path)")

    Managers.theme.setColorScheme(tint: .black, tram: .black, bus: .black)

    let tramView = self.createTramView(imageSize)
    let tramUrl  = documentsDirectory.appendingPathComponent("Image_Colors_Trams.png")
    self.saveView(tramView, to: tramUrl, scale: imageScale)

    let busView = self.createBusView(imageSize)
    let busUrl  = documentsDirectory.appendingPathComponent("Image_Colors_Busses.png")
    self.saveView(busView, to: busUrl, scale: imageScale)
  }

  private static func createTramView(_ frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    addPin(to: view, Line(name:  "4", type: .tram, subtype: .regular), CGPoint(x:  38.5, y: 340.0),  50.0)
    addPin(to: view, Line(name:  "4", type: .tram, subtype: .regular), CGPoint(x: 278.5, y: 283.0), 255.0)
    addPin(to: view, Line(name:  "6", type: .tram, subtype: .regular), CGPoint(x: 246.0, y:  93.5), 240.0)
    addPin(to: view, Line(name:  "6", type: .tram, subtype: .regular), CGPoint(x: 140.0, y: 212.5), 240.0)
    addPin(to: view, Line(name:  "7", type: .tram, subtype: .regular), CGPoint(x: 152.5, y: 307.5),  10.0)
    addPin(to: view, Line(name:  "7", type: .tram, subtype: .regular), CGPoint(x: 108.0, y: 375.5),  20.0)
    addPin(to: view, Line(name: "14", type: .tram, subtype: .regular), CGPoint(x: 128.5, y: 93.0),  -10.0)
    addPin(to: view, Line(name: "14", type: .tram, subtype: .regular), CGPoint(x: 115.5, y: 222.5), 240.0)
    addPin(to: view, Line(name: "17", type: .tram, subtype: .regular), CGPoint(x: 205.0, y: 251.0), 190.0)
    addPin(to: view, Line(name: "17", type: .tram, subtype: .regular), CGPoint(x: 199.5, y: 294.5),  10.0)
    addPin(to: view, Line(name: "23", type: .tram, subtype: .regular), CGPoint(x: 222.0, y: 182.5),  20.0)
    return view
  }

  private static func createBusView(_ frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    addPin(to: view, Line(name:   "C", type:  .bus, subtype: .express), CGPoint(x: 144.5, y: 156.0),   50.0)
    addPin(to: view, Line(name: "104", type:  .bus, subtype: .regular), CGPoint(x:  33.0, y: 229.5),  -40.0)
    addPin(to: view, Line(name: "106", type:  .bus, subtype: .regular), CGPoint(x: 109.0, y: 332.5),  -35.0)
    addPin(to: view, Line(name: "109", type:  .bus, subtype: .regular), CGPoint(x:  16.5, y: 280.0), -100.0)
    addPin(to: view, Line(name: "125", type:  .bus, subtype: .regular), CGPoint(x: 220.0, y: 454.0),  240.0)
    addPin(to: view, Line(name: "142", type:  .bus, subtype: .regular), CGPoint(x: 102.0, y:  24.0),  -15.0)
    addPin(to: view, Line(name: "142", type:  .bus, subtype: .regular), CGPoint(x:  87.5, y: 256.5),    0.0)
    addPin(to: view, Line(name: "146", type:  .bus, subtype: .regular), CGPoint(x: 149.5, y: 433.0),   10.0)
    return view
  }

  private static func addPin(to view: UIView, _ line: Line, _ origin: CGPoint, _ angle: Double) {
    let vehicle           = Vehicle(id: "", line: line, latitude: 0.0, longitude: 0.0, angle: angle)
    let vehicleAnnotation = VehicleAnnotation(from: vehicle)
    let annotationView    = VehicleAnnotationView(vehicleAnnotation, reuseIdentifier: "")
    annotationView.frame.origin = origin

    view.addSubview(annotationView)
  }

  private static func saveView(_ view: UIView, to url: URL, scale: CGFloat) {
    let format = UIGraphicsImageRendererFormat()
    format.prefersExtendedRange = false
    format.opaque               = false
    format.scale                = scale

    let renderer = UIGraphicsImageRenderer(size: view.bounds.size, format: format)
    let data = renderer.pngData { context in
      view.layer.render(in: context.cgContext)
    }

    do {
      try data.write(to: url)
    } catch {
      print("Error when generating images: \(error)")
    }
  }
}
