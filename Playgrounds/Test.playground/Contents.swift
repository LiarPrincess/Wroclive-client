//: Playground - noun: a place where people can play

import UIKit
import SnapKit
import PlaygroundSupport

let placeholder = UIView(frame: CGRect(x: 0, y: 0, width: 480, height: 300))
placeholder.backgroundColor = UIColor.white

func configure(_ label: UILabel) {
  label.textAlignment = .center
  label.numberOfLines = 0
}



let topLabel = UILabel()
configure(topLabel)
topLabel.text = "You have no bookmarks saved :-("
//topLabel.font = FontManager.instance.bookmarkCellTitle
placeholder.addSubview(topLabel)

topLabel.snp.makeConstraints { make in
  make.top.equalToSuperview().offset(40.0)
  make.left.equalToSuperview().offset(250.0)
  make.right.equalToSuperview().offset(-50.0)
}



let bottomLabel = UILabel()
configure(bottomLabel)
bottomLabel.text = "Tap x on any bus stop to save it here"
//topLabel.font = FontManager.instance.bookmarkCellContent // caps
placeholder.addSubview(bottomLabel)

bottomLabel.snp.makeConstraints { make in
  make.top.equalTo(topLabel.snp.bottom)
  make.left.equalTo(topLabel.snp.left)
  make.right.equalTo(topLabel.snp.right)
}

// ----------

topLabel.backgroundColor = UIColor.red
//topLabel.setContentHuggingPriority(1000, for: .vertical)

bottomLabel.backgroundColor = UIColor.green
//bottomLabel.setContentHuggingPriority(900, for: .vertical)

PlaygroundPage.current.liveView = placeholder
