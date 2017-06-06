//: Playground - noun: a place where people can play

import UIKit
import SnapKit
import PlaygroundSupport

let placeholder = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 260))
placeholder.backgroundColor = UIColor.white

let topLabel = UILabel()
topLabel.textAlignment = .center //.justified
topLabel.numberOfLines = 0
topLabel.text = "Bookmark name"
placeholder.addSubview(topLabel)

topLabel.snp.makeConstraints { make in
  make.top.equalToSuperview()
  make.left.equalToSuperview()
  make.right.equalToSuperview()
}

let bottomLabel = UILabel()
bottomLabel.textAlignment = .center //.justified
bottomLabel.numberOfLines = 0
bottomLabel.text = "You belong with me I wish you would. Romeo cheshire cat smile palm of your. Hand Olivia Benson rhode island screaming color. Rose garden this sick beat crystal. Skies it drives you crazy."
placeholder.addSubview(bottomLabel)

bottomLabel.snp.makeConstraints { make in
  make.top.equalTo(topLabel.snp.bottom)
  make.left.equalTo(topLabel.snp.left)
  make.right.equalTo(topLabel.snp.right)
}

//topLabel.backgroundColor = UIColor.red
//bottomLabel.backgroundColor = UIColor.green

PlaygroundPage.current.liveView = placeholder
