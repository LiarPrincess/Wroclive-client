use_frameworks!

platform :ios, "11.0"

target 'Wroclive' do
  pod 'ReSwift', '~> 4.0'

  pod 'Alamofire',         '~> 4.5'
  pod 'ReachabilitySwift', '~> 4.1'

  pod 'RxSwift',        '~> 4.0'
  pod 'RxCocoa',        '~> 4.0'
  pod 'RxAlamofire',    '~> 4.0'
  pod 'RxCoreLocation', '~> 1.0.0'

  pod 'SimulatorStatusMagic', '~> 2.0', :configurations => ['Debug']

  target 'WrocliveTests' do
    pod 'RxTest', '~> 4.0'
  end
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
