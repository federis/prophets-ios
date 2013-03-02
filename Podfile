platform :ios, '6.0'
pod 'RestKit', :git => 'https://github.com/RestKit/RestKit.git', :branch => 'development'
pod 'SVProgressHUD', :git => 'https://github.com/samvermette/SVProgressHUD.git'
pod 'PonyDebugger', '~>0.1.0'
pod 'Lockbox'

# Testing and Search are optional components
pod 'RestKit/Testing',  :git => 'https://github.com/RestKit/RestKit.git', :branch => 'development'

# For PonyDebugger
post_install do |installer|
    dTarget = target_definitions[:default]
    macro = "#if (defined __IPHONE_6_0 && TARGET_OS_IPHONE && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0)) || (defined MAC_OS_X_VERSION_10_8 && TARGET_OS_MAC && (MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_8))
 #undef dispatch_release
 #define dispatch_release(object) {}
 #undef dispatch_retain
 #define dispatch_retain(object) {}
 #endif"
    path = dTarget.relative_to_srcroot(dTarget.prefix_header_name)
    puts `echo \"#{macro}\" >> Pods/#{path}`
    puts 
end