use_frameworks!

platform :ios, "11.0"
inhibit_all_warnings!

target 'Wroclive' do
end

target 'WrocliveFramework' do
  pod 'ReSwift', '~> 4.0'

  pod 'Alamofire',         '~> 4.8'
  pod 'ReachabilitySwift', '~> 4.3'

  pod 'RxSwift',        '~> 4.3'
  pod 'RxCocoa',        '~> 4.3'
  pod 'RxAlamofire',    '~> 4.3'
  pod 'RxCoreLocation', '~> 1.3'

  pod 'SimulatorStatusMagic', '~> 2.4', :configuration => ['Debug']

  target 'WrocliveTests' do
    inherit! :search_paths
    pod 'RxTest', '~> 4.4'
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
