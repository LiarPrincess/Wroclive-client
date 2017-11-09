use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "10.2"

pod 'SnapKit',                           '~> 3.2.0'
pod 'Alamofire',                         '~> 4.4'
pod 'AlamofireNetworkActivityIndicator', '~> 2.2'
pod 'PromiseKit',                        '~> 4.0'
pod 'PromiseKit/Alamofire',              '~> 4.0'

target 'Radar' do
end

target 'Radar-Framework' do
end

abstract_target 'Tests' do
  pod 'Quick',  '~> 1.2.0'
  pod 'Nimble', '~> 7.0.2'
  
  target 'Radar-Tests' do
  end
  
  target 'Radar-Screenshots' do
  end
end
