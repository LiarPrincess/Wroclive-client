use_frameworks!

platform :ios, "10.2"

target 'Wroclive' do
  pod 'SnapKit', '~> 4.0'
  pod 'Result',  '~> 3.0'

  pod 'Alamofire',                         '~> 4.5'
  pod 'AlamofireNetworkActivityIndicator', '~> 2.2'
  pod 'ReachabilitySwift',                 '~> 4.1'

  pod 'RxSwift',        '~> 4.0'
  pod 'RxCocoa',        '~> 4.0'
  pod 'RxAlamofire',    '~> 4.0'
  pod 'RxCoreLocation', '~> 1.0.0'

  pod 'SimulatorStatusMagic', '~> 2.0', :configurations => ['Debug']

  target 'Wroclive-Tests' do
    pod 'RxTest', '~> 4.0'
  end
end

target 'Wroclive-Screenshots' do
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
     if target.name == 'RxSwift'
        target.build_configurations.each do |config|
           if config.name == 'Debug'
              config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
           end
        end
     end
  end
end
