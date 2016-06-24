source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

project 'HighPerformance.xcodeproj'
workspace 'HighPerformance.xcworkspace'

def install_deps
	pod 'CocoaLumberjack', '2.0.1'
	pod 'AFNetworking', '2.4.1'
	pod 'ReactiveCocoa', '2.5'
	pod 'PonyDebugger', '0.4.3'
end

target :HighPerformance do
	install_deps

	target :HighPerformanceTests do
		inherit! :search_paths
		pod 'OCMock', '~> 3.1'
		pod 'Expecta', '~> 0.2.4'
	end

end
