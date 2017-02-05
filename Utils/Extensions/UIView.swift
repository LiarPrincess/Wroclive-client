//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

extension UIView {

  //credits: http://stackoverflow.com/a/30519213
  func addBorder(edges: UIRectEdge, color: UIColor, thickness: CGFloat) {

    func createBorder() -> UIView {
      let border = UIView(frame: .zero)
      border.backgroundColor = color
      border.translatesAutoresizingMaskIntoConstraints = false
      return border
    }

    if edges.contains(.top) || edges.contains(.all) {
      let top = createBorder()
      addSubview(top)
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]", options: [], metrics: ["thickness": thickness], views: ["top": top]))
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|", options: [], metrics: nil, views: ["top": top]))
    }

    if edges.contains(.left) || edges.contains(.all) {
      let left = createBorder()
      addSubview(left)
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]", options: [], metrics: ["thickness": thickness], views: ["left": left]))
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|", options: [], metrics: nil, views: ["left": left]))
    }

    if edges.contains(.right) || edges.contains(.all) {
      let right = createBorder()
      addSubview(right)
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|", options: [], metrics: ["thickness": thickness], views: ["right": right]))
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|", options: [], metrics: nil, views: ["right": right]))
    }

    if edges.contains(.bottom) || edges.contains(.all) {
      let bottom = createBorder()
      addSubview(bottom)
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|", options: [], metrics: ["thickness": thickness], views: ["bottom": bottom]))
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|", options: [], metrics: nil, views: ["bottom": bottom]))
    }
  }
  
}

