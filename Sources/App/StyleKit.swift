// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_unwrapping
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
// swiftlint:disable file_length
// swiftlint:disable identifier_name

public class StyleKit : NSObject {

  //// Drawing Methods

  @objc
  dynamic public class func drawSearch(
    frame targetFrame: CGRect           = CGRect(x: 0, y: 0, width: 60, height: 60),
    resizing:          ResizingBehavior = .aspectFit) {

    //// General Declarations
    let context = UIGraphicsGetCurrentContext()!
    context.saveGState()

    //// Resize to Target Frame
    let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 60, height: 60), target: targetFrame)
    context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
    context.scaleBy(x: resizedFrame.width / 60, y: resizedFrame.height / 60)

    //// Color Declarations
    let fillColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)

    //// Handle Drawing
    context.saveGState()
    context.translateBy(x: 50.82, y: 50.82)
    context.rotate(by: -45 * CGFloat.pi/180)

    let handlePath = UIBezierPath(rect: CGRect(x: -0.5, y: -10.71, width: 1, height: 21.42))
    fillColor.setStroke()
    handlePath.lineWidth = 3.5
    handlePath.lineJoinStyle = .round
    handlePath.stroke()

    context.restoreGState()

    //// Glass Drawing
    let glassPath = UIBezierPath(ovalIn: CGRect(x: 1.25, y: 1.25, width: 48.25, height: 48.25))
    fillColor.setStroke()
    glassPath.lineWidth = 3.5
    glassPath.stroke()

    context.restoreGState()
  }

  @objc
  dynamic public class func drawStar(
    frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 60),
    resizing: ResizingBehavior = .aspectFit) {

    //// General Declarations
    let context = UIGraphicsGetCurrentContext()!

    //// Resize to Target Frame
    context.saveGState()
    let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 60, height: 60), target: targetFrame)
    context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
    context.scaleBy(x: resizedFrame.width / 60, y: resizedFrame.height / 60)

    //// Shape Drawing
    let shapePath = UIBezierPath()
    shapePath.move(to: CGPoint(x: 30, y: 1.25))
    shapePath.addLine(to: CGPoint(x: 39.19, y: 19.71))
    shapePath.addLine(to: CGPoint(x: 58.74, y: 23.19))
    shapePath.addLine(to: CGPoint(x: 44.87, y: 38.07))
    shapePath.addLine(to: CGPoint(x: 47.77, y: 58.68))
    shapePath.addLine(to: CGPoint(x: 30, y: 49.42))
    shapePath.addLine(to: CGPoint(x: 12.24, y: 58.68))
    shapePath.addLine(to: CGPoint(x: 15.13, y: 38.07))
    shapePath.addLine(to: CGPoint(x: 1.26, y: 23.19))
    shapePath.addLine(to: CGPoint(x: 20.81, y: 19.71))
    shapePath.close()
    UIColor.black.setStroke()
    shapePath.lineWidth = 2.5
    shapePath.lineJoinStyle = .round
    shapePath.stroke()

    context.restoreGState()
  }

  @objc
  dynamic public class func drawStarFilled(
    frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 60),
    resizing: ResizingBehavior = .aspectFit) {

    //// General Declarations
    let context = UIGraphicsGetCurrentContext()!

    //// Resize to Target Frame
    context.saveGState()
    let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 60, height: 60), target: targetFrame)
    context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
    context.scaleBy(x: resizedFrame.width / 60, y: resizedFrame.height / 60)

    //// Shape Drawing
    let shapePath = UIBezierPath()
    shapePath.move(to: CGPoint(x: 30, y: 1.25))
    shapePath.addLine(to: CGPoint(x: 39.19, y: 19.71))
    shapePath.addLine(to: CGPoint(x: 58.74, y: 23.19))
    shapePath.addLine(to: CGPoint(x: 44.87, y: 38.07))
    shapePath.addLine(to: CGPoint(x: 47.77, y: 58.68))
    shapePath.addLine(to: CGPoint(x: 30, y: 49.42))
    shapePath.addLine(to: CGPoint(x: 12.24, y: 58.68))
    shapePath.addLine(to: CGPoint(x: 15.13, y: 38.07))
    shapePath.addLine(to: CGPoint(x: 1.26, y: 23.19))
    shapePath.addLine(to: CGPoint(x: 20.81, y: 19.71))
    shapePath.close()
    UIColor.black.setStroke()
    UIColor.black.setFill()
    shapePath.lineWidth = 2.5
    shapePath.lineJoinStyle = .round
    shapePath.stroke()
    shapePath.fill()

    context.restoreGState()
  }

  @objc
  dynamic public class func drawCogwheel(
    frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 60),
    resizing: ResizingBehavior = .aspectFit) {

    //// General Declarations
    let context = UIGraphicsGetCurrentContext()!

    //// Resize to Target Frame
    context.saveGState()
    let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 60, height: 60), target: targetFrame)
    context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
    context.scaleBy(x: resizedFrame.width / 60, y: resizedFrame.height / 60)

    //// Color Declarations
    let fillColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)

    //// Outer Drawing
    let outerPath = UIBezierPath()
    outerPath.move(to: CGPoint(x: 56.91, y: 23.33))
    outerPath.addLine(to: CGPoint(x: 51.3, y: 23.33))
    outerPath.addCurve(to: CGPoint(x: 49.31, y: 22), controlPoint1: CGPoint(x: 50.4, y: 23.33), controlPoint2: CGPoint(x: 49.65, y: 22.84))
    outerPath.addCurve(to: CGPoint(x: 49.77, y: 19.65), controlPoint1: CGPoint(x: 48.96, y: 21.17), controlPoint2: CGPoint(x: 49.14, y: 20.29))
    outerPath.addLine(to: CGPoint(x: 53.74, y: 15.69))
    outerPath.addCurve(to: CGPoint(x: 54.65, y: 13.5), controlPoint1: CGPoint(x: 54.33, y: 15.1), controlPoint2: CGPoint(x: 54.65, y: 14.33))
    outerPath.addCurve(to: CGPoint(x: 53.74, y: 11.32), controlPoint1: CGPoint(x: 54.65, y: 12.68), controlPoint2: CGPoint(x: 54.33, y: 11.9))
    outerPath.addLine(to: CGPoint(x: 48.68, y: 6.26))
    outerPath.addCurve(to: CGPoint(x: 44.31, y: 6.26), controlPoint1: CGPoint(x: 47.52, y: 5.09), controlPoint2: CGPoint(x: 45.48, y: 5.09))
    outerPath.addLine(to: CGPoint(x: 40.35, y: 10.23))
    outerPath.addCurve(to: CGPoint(x: 38, y: 10.69), controlPoint1: CGPoint(x: 39.71, y: 10.86), controlPoint2: CGPoint(x: 38.83, y: 11.04))
    outerPath.addCurve(to: CGPoint(x: 36.67, y: 8.7), controlPoint1: CGPoint(x: 37.16, y: 10.35), controlPoint2: CGPoint(x: 36.67, y: 9.6))
    outerPath.addLine(to: CGPoint(x: 36.67, y: 3.09))
    outerPath.addCurve(to: CGPoint(x: 33.58, y: 0), controlPoint1: CGPoint(x: 36.67, y: 1.39), controlPoint2: CGPoint(x: 35.28, y: 0))
    outerPath.addLine(to: CGPoint(x: 26.42, y: 0))
    outerPath.addCurve(to: CGPoint(x: 23.33, y: 3.09), controlPoint1: CGPoint(x: 24.72, y: 0), controlPoint2: CGPoint(x: 23.33, y: 1.39))
    outerPath.addLine(to: CGPoint(x: 23.33, y: 8.7))
    outerPath.addCurve(to: CGPoint(x: 22, y: 10.69), controlPoint1: CGPoint(x: 23.33, y: 9.6), controlPoint2: CGPoint(x: 22.84, y: 10.35))
    outerPath.addCurve(to: CGPoint(x: 19.65, y: 10.23), controlPoint1: CGPoint(x: 21.17, y: 11.04), controlPoint2: CGPoint(x: 20.29, y: 10.86))
    outerPath.addLine(to: CGPoint(x: 15.69, y: 6.26))
    outerPath.addCurve(to: CGPoint(x: 11.32, y: 6.26), controlPoint1: CGPoint(x: 14.52, y: 5.09), controlPoint2: CGPoint(x: 12.48, y: 5.09))
    outerPath.addLine(to: CGPoint(x: 6.26, y: 11.32))
    outerPath.addCurve(to: CGPoint(x: 5.35, y: 13.5), controlPoint1: CGPoint(x: 5.67, y: 11.9), controlPoint2: CGPoint(x: 5.35, y: 12.68))
    outerPath.addCurve(to: CGPoint(x: 6.26, y: 15.69), controlPoint1: CGPoint(x: 5.35, y: 14.33), controlPoint2: CGPoint(x: 5.67, y: 15.1))
    outerPath.addLine(to: CGPoint(x: 10.23, y: 19.65))
    outerPath.addCurve(to: CGPoint(x: 10.69, y: 22), controlPoint1: CGPoint(x: 10.86, y: 20.29), controlPoint2: CGPoint(x: 11.04, y: 21.17))
    outerPath.addCurve(to: CGPoint(x: 8.7, y: 23.33), controlPoint1: CGPoint(x: 10.35, y: 22.84), controlPoint2: CGPoint(x: 9.6, y: 23.33))
    outerPath.addLine(to: CGPoint(x: 3.09, y: 23.33))
    outerPath.addCurve(to: CGPoint(x: 0, y: 26.42), controlPoint1: CGPoint(x: 1.39, y: 23.33), controlPoint2: CGPoint(x: 0, y: 24.72))
    outerPath.addLine(to: CGPoint(x: 0, y: 33.58))
    outerPath.addCurve(to: CGPoint(x: 3.09, y: 36.67), controlPoint1: CGPoint(x: 0, y: 35.28), controlPoint2: CGPoint(x: 1.39, y: 36.67))
    outerPath.addLine(to: CGPoint(x: 8.7, y: 36.67))
    outerPath.addCurve(to: CGPoint(x: 10.69, y: 38), controlPoint1: CGPoint(x: 9.6, y: 36.67), controlPoint2: CGPoint(x: 10.35, y: 37.16))
    outerPath.addCurve(to: CGPoint(x: 10.23, y: 40.35), controlPoint1: CGPoint(x: 11.04, y: 38.83), controlPoint2: CGPoint(x: 10.86, y: 39.71))
    outerPath.addLine(to: CGPoint(x: 6.26, y: 44.31))
    outerPath.addCurve(to: CGPoint(x: 5.35, y: 46.5), controlPoint1: CGPoint(x: 5.67, y: 44.9), controlPoint2: CGPoint(x: 5.35, y: 45.67))
    outerPath.addCurve(to: CGPoint(x: 6.26, y: 48.68), controlPoint1: CGPoint(x: 5.35, y: 47.32), controlPoint2: CGPoint(x: 5.67, y: 48.1))
    outerPath.addLine(to: CGPoint(x: 11.32, y: 53.74))
    outerPath.addCurve(to: CGPoint(x: 15.69, y: 53.74), controlPoint1: CGPoint(x: 12.48, y: 54.91), controlPoint2: CGPoint(x: 14.52, y: 54.91))
    outerPath.addLine(to: CGPoint(x: 19.65, y: 49.77))
    outerPath.addCurve(to: CGPoint(x: 22, y: 49.31), controlPoint1: CGPoint(x: 20.29, y: 49.14), controlPoint2: CGPoint(x: 21.17, y: 48.96))
    outerPath.addCurve(to: CGPoint(x: 23.33, y: 51.3), controlPoint1: CGPoint(x: 22.84, y: 49.65), controlPoint2: CGPoint(x: 23.33, y: 50.4))
    outerPath.addLine(to: CGPoint(x: 23.33, y: 56.91))
    outerPath.addCurve(to: CGPoint(x: 26.42, y: 60), controlPoint1: CGPoint(x: 23.33, y: 58.61), controlPoint2: CGPoint(x: 24.72, y: 60))
    outerPath.addLine(to: CGPoint(x: 33.58, y: 60))
    outerPath.addCurve(to: CGPoint(x: 36.67, y: 56.91), controlPoint1: CGPoint(x: 35.28, y: 60), controlPoint2: CGPoint(x: 36.67, y: 58.61))
    outerPath.addLine(to: CGPoint(x: 36.67, y: 51.3))
    outerPath.addCurve(to: CGPoint(x: 38, y: 49.31), controlPoint1: CGPoint(x: 36.67, y: 50.4), controlPoint2: CGPoint(x: 37.16, y: 49.65))
    outerPath.addCurve(to: CGPoint(x: 40.34, y: 49.77), controlPoint1: CGPoint(x: 38.83, y: 48.96), controlPoint2: CGPoint(x: 39.71, y: 49.14))
    outerPath.addLine(to: CGPoint(x: 44.31, y: 53.74))
    outerPath.addCurve(to: CGPoint(x: 48.68, y: 53.74), controlPoint1: CGPoint(x: 45.48, y: 54.91), controlPoint2: CGPoint(x: 47.52, y: 54.91))
    outerPath.addLine(to: CGPoint(x: 53.74, y: 48.68))
    outerPath.addCurve(to: CGPoint(x: 54.65, y: 46.5), controlPoint1: CGPoint(x: 54.32, y: 48.1), controlPoint2: CGPoint(x: 54.65, y: 47.32))
    outerPath.addCurve(to: CGPoint(x: 53.74, y: 44.31), controlPoint1: CGPoint(x: 54.65, y: 45.67), controlPoint2: CGPoint(x: 54.32, y: 44.9))
    outerPath.addLine(to: CGPoint(x: 49.77, y: 40.35))
    outerPath.addCurve(to: CGPoint(x: 49.31, y: 38), controlPoint1: CGPoint(x: 49.14, y: 39.71), controlPoint2: CGPoint(x: 48.96, y: 38.83))
    outerPath.addCurve(to: CGPoint(x: 51.3, y: 36.67), controlPoint1: CGPoint(x: 49.65, y: 37.16), controlPoint2: CGPoint(x: 50.4, y: 36.67))
    outerPath.addLine(to: CGPoint(x: 56.91, y: 36.67))
    outerPath.addCurve(to: CGPoint(x: 60, y: 33.58), controlPoint1: CGPoint(x: 58.61, y: 36.67), controlPoint2: CGPoint(x: 60, y: 35.28))
    outerPath.addLine(to: CGPoint(x: 60, y: 26.42))
    outerPath.addCurve(to: CGPoint(x: 56.91, y: 23.33), controlPoint1: CGPoint(x: 60, y: 24.72), controlPoint2: CGPoint(x: 58.61, y: 23.33))
    outerPath.close()
    outerPath.move(to: CGPoint(x: 57.78, y: 33.58))
    outerPath.addCurve(to: CGPoint(x: 56.91, y: 34.44), controlPoint1: CGPoint(x: 57.78, y: 34.06), controlPoint2: CGPoint(x: 57.39, y: 34.44))
    outerPath.addLine(to: CGPoint(x: 51.3, y: 34.44))
    outerPath.addCurve(to: CGPoint(x: 47.25, y: 37.15), controlPoint1: CGPoint(x: 49.49, y: 34.44), controlPoint2: CGPoint(x: 47.94, y: 35.48))
    outerPath.addCurve(to: CGPoint(x: 48.2, y: 41.92), controlPoint1: CGPoint(x: 46.56, y: 38.81), controlPoint2: CGPoint(x: 46.93, y: 40.64))
    outerPath.addLine(to: CGPoint(x: 52.17, y: 45.89))
    outerPath.addCurve(to: CGPoint(x: 52.17, y: 47.11), controlPoint1: CGPoint(x: 52.51, y: 46.22), controlPoint2: CGPoint(x: 52.51, y: 46.77))
    outerPath.addLine(to: CGPoint(x: 47.11, y: 52.17))
    outerPath.addCurve(to: CGPoint(x: 45.89, y: 52.17), controlPoint1: CGPoint(x: 46.77, y: 52.51), controlPoint2: CGPoint(x: 46.22, y: 52.51))
    outerPath.addLine(to: CGPoint(x: 41.92, y: 48.2))
    outerPath.addCurve(to: CGPoint(x: 37.15, y: 47.25), controlPoint1: CGPoint(x: 40.64, y: 46.93), controlPoint2: CGPoint(x: 38.81, y: 46.56))
    outerPath.addCurve(to: CGPoint(x: 34.44, y: 51.3), controlPoint1: CGPoint(x: 35.48, y: 47.94), controlPoint2: CGPoint(x: 34.44, y: 49.49))
    outerPath.addLine(to: CGPoint(x: 34.44, y: 56.91))
    outerPath.addCurve(to: CGPoint(x: 33.58, y: 57.78), controlPoint1: CGPoint(x: 34.44, y: 57.39), controlPoint2: CGPoint(x: 34.06, y: 57.78))
    outerPath.addLine(to: CGPoint(x: 26.42, y: 57.78))
    outerPath.addCurve(to: CGPoint(x: 25.56, y: 56.91), controlPoint1: CGPoint(x: 25.94, y: 57.78), controlPoint2: CGPoint(x: 25.56, y: 57.39))
    outerPath.addLine(to: CGPoint(x: 25.56, y: 51.3))
    outerPath.addCurve(to: CGPoint(x: 22.85, y: 47.25), controlPoint1: CGPoint(x: 25.56, y: 49.49), controlPoint2: CGPoint(x: 24.52, y: 47.94))
    outerPath.addCurve(to: CGPoint(x: 21.15, y: 46.91), controlPoint1: CGPoint(x: 22.29, y: 47.02), controlPoint2: CGPoint(x: 21.72, y: 46.91))
    outerPath.addCurve(to: CGPoint(x: 18.08, y: 48.2), controlPoint1: CGPoint(x: 20.02, y: 46.91), controlPoint2: CGPoint(x: 18.93, y: 47.35))
    outerPath.addLine(to: CGPoint(x: 14.11, y: 52.17))
    outerPath.addCurve(to: CGPoint(x: 12.89, y: 52.17), controlPoint1: CGPoint(x: 13.77, y: 52.51), controlPoint2: CGPoint(x: 13.22, y: 52.51))
    outerPath.addLine(to: CGPoint(x: 7.83, y: 47.11))
    outerPath.addCurve(to: CGPoint(x: 7.83, y: 45.88), controlPoint1: CGPoint(x: 7.49, y: 46.77), controlPoint2: CGPoint(x: 7.49, y: 46.22))
    outerPath.addLine(to: CGPoint(x: 11.8, y: 41.92))
    outerPath.addCurve(to: CGPoint(x: 12.75, y: 37.15), controlPoint1: CGPoint(x: 13.07, y: 40.64), controlPoint2: CGPoint(x: 13.44, y: 38.81))
    outerPath.addCurve(to: CGPoint(x: 8.7, y: 34.44), controlPoint1: CGPoint(x: 12.06, y: 35.48), controlPoint2: CGPoint(x: 10.51, y: 34.44))
    outerPath.addLine(to: CGPoint(x: 3.09, y: 34.44))
    outerPath.addCurve(to: CGPoint(x: 2.22, y: 33.58), controlPoint1: CGPoint(x: 2.61, y: 34.44), controlPoint2: CGPoint(x: 2.22, y: 34.06))
    outerPath.addLine(to: CGPoint(x: 2.22, y: 26.42))
    outerPath.addCurve(to: CGPoint(x: 3.09, y: 25.56), controlPoint1: CGPoint(x: 2.22, y: 25.94), controlPoint2: CGPoint(x: 2.61, y: 25.56))
    outerPath.addLine(to: CGPoint(x: 8.7, y: 25.56))
    outerPath.addCurve(to: CGPoint(x: 12.75, y: 22.85), controlPoint1: CGPoint(x: 10.51, y: 25.56), controlPoint2: CGPoint(x: 12.06, y: 24.52))
    outerPath.addCurve(to: CGPoint(x: 11.8, y: 18.08), controlPoint1: CGPoint(x: 13.44, y: 21.19), controlPoint2: CGPoint(x: 13.07, y: 19.36))
    outerPath.addLine(to: CGPoint(x: 7.83, y: 14.11))
    outerPath.addCurve(to: CGPoint(x: 7.83, y: 12.89), controlPoint1: CGPoint(x: 7.49, y: 13.78), controlPoint2: CGPoint(x: 7.49, y: 13.23))
    outerPath.addLine(to: CGPoint(x: 12.89, y: 7.83))
    outerPath.addCurve(to: CGPoint(x: 14.11, y: 7.83), controlPoint1: CGPoint(x: 13.23, y: 7.49), controlPoint2: CGPoint(x: 13.78, y: 7.49))
    outerPath.addLine(to: CGPoint(x: 18.08, y: 11.8))
    outerPath.addCurve(to: CGPoint(x: 22.85, y: 12.75), controlPoint1: CGPoint(x: 19.36, y: 13.07), controlPoint2: CGPoint(x: 21.18, y: 13.44))
    outerPath.addCurve(to: CGPoint(x: 25.56, y: 8.7), controlPoint1: CGPoint(x: 24.52, y: 12.06), controlPoint2: CGPoint(x: 25.56, y: 10.51))
    outerPath.addLine(to: CGPoint(x: 25.56, y: 3.09))
    outerPath.addCurve(to: CGPoint(x: 26.42, y: 2.22), controlPoint1: CGPoint(x: 25.56, y: 2.61), controlPoint2: CGPoint(x: 25.94, y: 2.22))
    outerPath.addLine(to: CGPoint(x: 33.58, y: 2.22))
    outerPath.addCurve(to: CGPoint(x: 34.44, y: 3.09), controlPoint1: CGPoint(x: 34.06, y: 2.22), controlPoint2: CGPoint(x: 34.44, y: 2.61))
    outerPath.addLine(to: CGPoint(x: 34.44, y: 8.7))
    outerPath.addCurve(to: CGPoint(x: 37.15, y: 12.75), controlPoint1: CGPoint(x: 34.44, y: 10.51), controlPoint2: CGPoint(x: 35.48, y: 12.06))
    outerPath.addCurve(to: CGPoint(x: 41.92, y: 11.8), controlPoint1: CGPoint(x: 38.82, y: 13.44), controlPoint2: CGPoint(x: 40.64, y: 13.07))
    outerPath.addLine(to: CGPoint(x: 45.89, y: 7.83))
    outerPath.addCurve(to: CGPoint(x: 47.11, y: 7.83), controlPoint1: CGPoint(x: 46.23, y: 7.49), controlPoint2: CGPoint(x: 46.78, y: 7.49))
    outerPath.addLine(to: CGPoint(x: 52.17, y: 12.89))
    outerPath.addCurve(to: CGPoint(x: 52.17, y: 14.12), controlPoint1: CGPoint(x: 52.51, y: 13.23), controlPoint2: CGPoint(x: 52.51, y: 13.78))
    outerPath.addLine(to: CGPoint(x: 48.2, y: 18.08))
    outerPath.addCurve(to: CGPoint(x: 47.25, y: 22.85), controlPoint1: CGPoint(x: 46.93, y: 19.36), controlPoint2: CGPoint(x: 46.56, y: 21.19))
    outerPath.addCurve(to: CGPoint(x: 51.3, y: 25.56), controlPoint1: CGPoint(x: 47.94, y: 24.52), controlPoint2: CGPoint(x: 49.49, y: 25.56))
    outerPath.addLine(to: CGPoint(x: 56.91, y: 25.56))
    outerPath.addCurve(to: CGPoint(x: 57.78, y: 26.42), controlPoint1: CGPoint(x: 57.39, y: 25.56), controlPoint2: CGPoint(x: 57.78, y: 25.94))
    outerPath.addLine(to: CGPoint(x: 57.78, y: 33.58))
    outerPath.close()
    fillColor.setFill()
    outerPath.fill()

    //// Inner Drawing
    let innerPath = UIBezierPath()
    innerPath.move(to: CGPoint(x: 30, y: 21))
    innerPath.addCurve(to: CGPoint(x: 21, y: 30), controlPoint1: CGPoint(x: 25.04, y: 21), controlPoint2: CGPoint(x: 21, y: 25.04))
    innerPath.addCurve(to: CGPoint(x: 30, y: 39), controlPoint1: CGPoint(x: 21, y: 34.96), controlPoint2: CGPoint(x: 25.04, y: 39))
    innerPath.addCurve(to: CGPoint(x: 39, y: 30), controlPoint1: CGPoint(x: 34.96, y: 39), controlPoint2: CGPoint(x: 39, y: 34.96))
    innerPath.addCurve(to: CGPoint(x: 30, y: 21), controlPoint1: CGPoint(x: 39, y: 25.04), controlPoint2: CGPoint(x: 34.96, y: 21))
    innerPath.close()
    innerPath.move(to: CGPoint(x: 30, y: 37))
    innerPath.addCurve(to: CGPoint(x: 23, y: 30), controlPoint1: CGPoint(x: 26.14, y: 37), controlPoint2: CGPoint(x: 23, y: 33.86))
    innerPath.addCurve(to: CGPoint(x: 30, y: 23), controlPoint1: CGPoint(x: 23, y: 26.14), controlPoint2: CGPoint(x: 26.14, y: 23))
    innerPath.addCurve(to: CGPoint(x: 37, y: 30), controlPoint1: CGPoint(x: 33.86, y: 23), controlPoint2: CGPoint(x: 37, y: 26.14))
    innerPath.addCurve(to: CGPoint(x: 30, y: 37), controlPoint1: CGPoint(x: 37, y: 33.86), controlPoint2: CGPoint(x: 33.86, y: 37))
    innerPath.close()
    fillColor.setFill()
    innerPath.fill()

    context.restoreGState()
  }

  @objc
  dynamic public class func drawVehiclePin(
    frame targetFrame: CGRect           = CGRect(x: 0, y: 0, width: 100, height: 100),
    color:             UIColor          = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000),
    resizing:          ResizingBehavior = .aspectFit) {
    // dimensions (x4):
    // arrow height: 24 |  6
    // arrow width:  64 | 16

    // arrow gap:      4 |  1
    // rect width:   128 | 32
    // total: 2 * (24 + 4) + 128 = 184 | 46

    // border width:    8 |  2
    // corners radius: 40 | 10

    // Constants
    let contextSize: CGFloat = 52.0

    let arrowWidth:  CGFloat = 16.0
    let arrowHeight: CGFloat =  6.0
    let arrowGap:    CGFloat =  2.0

    let rectBorderWidth:  CGFloat =  2.0
    let rectCornerRadius: CGFloat = 10.0
    let rectSize:         CGFloat = contextSize - 2 * (arrowHeight + arrowGap)

    let rectFrame = CGRect(x: arrowHeight + arrowGap, y: arrowHeight + arrowGap, width: rectSize, height: rectSize)

    // Drawing
    let context = UIGraphicsGetCurrentContext()!

    context.saveGState()
    let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0.0, y: 0.0, width: contextSize, height: contextSize), target: targetFrame)
    context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
    context.scaleBy(x: resizedFrame.width / contextSize, y: resizedFrame.height / contextSize)

    //// Rounded rect Drawing
    let rectPath  = UIBezierPath(roundedRect: rectFrame, cornerRadius: rectCornerRadius)
    color.withAlphaComponent(0.75).setFill()
    rectPath.fill()
    color.setStroke()
    rectPath.lineWidth = rectBorderWidth
    rectPath.stroke()

    //// Arrow Drawing
    let arrowPath = UIBezierPath()
    arrowPath.move(to: CGPoint(x: (contextSize - arrowWidth) / 2, y: arrowHeight))
    arrowPath.addLine(to: CGPoint(x: contextSize / 2, y: 0))
    arrowPath.addLine(to: CGPoint(x: (contextSize + arrowWidth) / 2, y: arrowHeight))
    arrowPath.close()
    color.setFill()
    arrowPath.fill()

    context.restoreGState()
  }

  @objc
  dynamic public class func drawClose(
    frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 60),
    resizing: ResizingBehavior = .aspectFit) {

    //// General Declarations
    let context = UIGraphicsGetCurrentContext()!

    //// Resize to Target Frame
    context.saveGState()
    let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 60, height: 60), target: targetFrame)
    context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
    context.scaleBy(x: resizedFrame.width / 60, y: resizedFrame.height / 60)

    //// Bezier Drawing
    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: 1.75, y: 1.75))
    bezierPath.addCurve(to: CGPoint(x: 58.25, y: 58.25), controlPoint1: CGPoint(x: 56.61, y: 56.61), controlPoint2: CGPoint(x: 58.25, y: 58.25))
    UIColor.black.setStroke()
    bezierPath.lineWidth = 7
    bezierPath.lineCapStyle = .round
    bezierPath.stroke()

    //// Bezier 2 Drawing
    context.saveGState()
    context.translateBy(x: 1.75, y: 58.25)
    context.rotate(by: -90 * CGFloat.pi/180)

    let bezier2Path = UIBezierPath()
    bezier2Path.move(to: CGPoint(x: 0, y: 0))
    bezier2Path.addCurve(to: CGPoint(x: 56.5, y: 56.5), controlPoint1: CGPoint(x: 54.86, y: 54.86), controlPoint2: CGPoint(x: 56.5, y: 56.5))
    UIColor.black.setStroke()
    bezier2Path.lineWidth = 7
    bezier2Path.lineCapStyle = .round
    bezier2Path.stroke()

    context.restoreGState()

    context.restoreGState()
  }

  @objc(StyleKitResizingBehavior)
  public enum ResizingBehavior: Int {
    case aspectFit /// The content is proportionally resized to fit into the target rectangle.
    case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
    case stretch /// The content is stretched to match the entire target rectangle.
    case center /// The content is centered in the target rectangle, but it is NOT resized.

    public func apply(rect: CGRect, target: CGRect) -> CGRect {
      if rect == target || target == CGRect.zero {
        return rect
      }

      var scales = CGSize.zero
      scales.width = abs(target.width / rect.width)
      scales.height = abs(target.height / rect.height)

      switch self {
      case .aspectFit:
        scales.width = min(scales.width, scales.height)
        scales.height = scales.width
      case .aspectFill:
        scales.width = max(scales.width, scales.height)
        scales.height = scales.width
      case .stretch:
        break
      case .center:
        scales.width = 1
        scales.height = 1
      }

      var result = rect.standardized
      result.size.width *= scales.width
      result.size.height *= scales.height
      result.origin.x = target.minX + (target.width - result.width) / 2
      result.origin.y = target.minY + (target.height - result.height) / 2
      return result
    }
  }
}
