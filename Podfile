# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'shopmaker' do
  use_frameworks!
	
  # Pods for lotteautolease
  pod 'CryptoSwift', '~> 1.3.8'
  pod 'Alamofire', '~> 5.2'
  pod 'Moya/RxSwift', '~> 14.0'
  pod 'RxSwift',    '~> 5'
  pod 'RxDataSources', '~> 4.0'
  pod 'RxSwiftExt', '~> 5'
  pod 'RxCocoa',    '~> 5'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
