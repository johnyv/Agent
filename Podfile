# Uncomment this line to define a global platform for your project
use_frameworks!

target 'Agent' do
	platform :ios, '8.0'
	pod 'WechatOpenSDK'
	pod 'MJRefresh'
	pod 'SVProgressHUD'
	pod 'SDWebImage'
	pod 'Alamofire'
 	pod 'Moya', '~> 9.0'
	pod 'SwiftyJSON'
	pod 'ObjectMapper', '~>2.2'
	pod 'SnapKit', '~> 3.0.0'
	pod 'PagingMenuController'
	pod 'XLPagerTabStrip', '~> 8.0'
	pod 'IQKeyboardManagerSwift'
	pod 'PopupController'
	pod 'HooDatePicker'
	pod 'Toast-Swift'
	pod 'TextFieldCounter'
end

post_install do |installer|
    #    `rm -rf Pods/Headers/Private`
	#    `find Pods -regex 'Pods\/.*\.modulemap' -print0 | xargs -0 sed -i '' 's/private header.*//'`
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['SWIFT_VERSION'] = '3.0'
		end
	end	
end
    