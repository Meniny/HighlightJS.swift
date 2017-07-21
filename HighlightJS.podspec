Pod::Spec.new do |s|
  s.name             = "HighlightJS"
  s.version          = "1.0.0"
  s.summary          = "A code syntax highlight library using Highlight.js"

  s.homepage         = "https://github.com/Meniny/HighlightJS.swift"
  s.license          = 'MIT'
  s.author           = { "Meniny" => "Meniny@qq.com" }
  s.source           = { :git => "https://github.com/Meniny/HighlightJS.swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://meniny.cn/'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'HighlightJS/Classes/**/*.swift'
  s.resources = 'HighlightJS/Assets/**/*.*'
  # s.public_header_files = ''
  s.frameworks = 'Foundation', 'JavaScriptCore'
end
