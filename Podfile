use_frameworks!

platform :ios, "10.2"

def app_pods
  pod 'SnapKit',                           '~> 3.2.0'
  pod 'Alamofire',                         '~> 4.4'
  pod 'AlamofireNetworkActivityIndicator', '~> 2.2'
  pod 'PromiseKit',                        '~> 4.0'
  pod 'PromiseKit/Alamofire',              '~> 4.0'
end

target 'Radar' do
  app_pods
end

target 'Radar-Framework' do
  app_pods
end

target 'Radar-Tests' do
  pod 'Quick',  '~> 1.2.0'
  pod 'Nimble', '~> 7.0.2'
end

target 'Radar-Screenshots' do
end
