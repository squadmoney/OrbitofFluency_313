require 'xcodeproj'
product_name = 'Runner'
project_file = product_name + '.xcodeproj'
project = Xcodeproj::Project.open(project_file)


# Adding .plist file
# file_name = 'GoogleService-Info.plist'
# group_name = product_name
# file = project.new_file(file_name)
# project.native_targets.first.add_resources([file])

# Adding Push Notification Capability
capa_file = 'Runner/' + 'Runner.entitlements'
project.root_object.build_configuration_list.build_configurations.each do |target|
    target.build_settings['CODE_SIGN_ENTITLEMENTS'] = capa_file
    target.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = "12.0"
    target.build_settings['TARGETED_DEVICE_FAMILY'] = "1"
end

open(capa_file, 'w') { |f|
f << '<?xml version="1.0" encoding="UTF-8"?>'
f << "\n"
f <<'<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'
f << "\n"
f << '<plist version="1.0">'
f << "\n"
f << '<dict>'
f << "\n"
f << '      <key>aps-environment</key>'
f << "\n"
f << '     <string>production</string>'
f << "\n"
f << '</dict>'
f << "\n"
f << '</plist>'
}
capa = project.new_file(capa_file)

project.save(project_file)

# fix Info.plist encoding issue
# info_plist_content = File.open("Info.plist", "r:bom|utf-8", &:read)
# File.write('Info.plist', info_plist_content)

# plist = Xcodeproj::Plist.read_from_path('Info.plist')

# plist['NSAppTransportSecurity'] = {'NSExceptionDomains' => {ENV["APP_DOMAIN"] => {'NSExceptionAllowsInsecureHTTPLoads' => true, 'NSIncludesSubdomains' => true}}}
# plist['NSLocationWhenInUseUsageDescription'] = "The app needs access to this location in order to receive up-to-date information for your location"
# plist['CFBundleDisplayName'] = ENV["APP_DISPLAY_NAME"]
# plist['CFBundleShortVersionString'] = ENV["APP_VERSION"]
# plist['CFBundleVersion'] = ENV["APP_BUILD"]

# Xcodeproj::Plist.write_to_path(plist, 'Info.plist')