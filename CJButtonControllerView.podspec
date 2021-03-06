Pod::Spec.new do |s|
  s.name         = "CJButtonControllerView"
  s.version      = "1.1.0"
  s.summary      = "由RadioButtons和RadioComposeView再组合使用的CJButtonControllerView"
  s.homepage     = "https://github.com/dvlproad/RadioButtons"
  s.license      = "MIT"
  s.author             = "dvlproad"
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/dvlproad/RadioButtons.git", :tag => "ButtonControllerView_1.1.0" }
  s.source_files  = "CJButtonControllerView/**/*.{h,m}"
  # s.resources = "CJButtonControllerView/**/*.{png,xib}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "RadioButtons", "~> 2.2.0"
  s.dependency "RadioComposeView", "~> 2.2.0"

end
