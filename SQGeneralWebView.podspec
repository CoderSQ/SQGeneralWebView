
Pod::Spec.new do |s|

  s.name         = "SQGeneralWebView"
  s.version      = "0.0.4"
  s.summary      = "This is a gengeral WebView ,use WebViewJavaScriptBridge as the bridge with native."

  s.homepage     = "https://github.com/CoderSQ/SQGeneralWebView.git"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "CoderSQ" => "steven_shuang@126.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/CoderSQ/SQGeneralWebView.git", :tag => "#{s.version}" }

  s.source_files  = "SQGeneralWebView", "*.{h,m}"
  #s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  #s.framework  = "UIKit"
  s.frameworks = "UIKit", "WebKit"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "WebViewJavascriptBridge", "~> 5.0.5"

end
