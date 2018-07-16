
Pod::Spec.new do |s|
  s.name         = "CGHSelectView"
  s.version      = "1.0.2"
  s.summary      = "A SelectView."
  s.homepage     = "https://github.com/JagainChen/JagainLocationSelectView"
  s.license      = "MIT"
  s.author             = { "Jagain" => "jagain@icloud.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/JagainChen/JagainLocationSelectView.git", :tag => "#{s.version}" }
  s.source_files  = 'CGHSelectView/*.{h,m}'
  s.framework  = "UIKit"
  s.dependency "Masonry", "~> 1.1.0"
end
