
Pod::Spec.new do |s|
  s.name         = "CGHSelectView"
  s.version      = "1.0.1"
  s.summary      = "A SelectView."
  s.homepage     = "http://github.com/JagainChen/JagainLocationSelectView"
  s.license      = "MIT"
  s.author             = { "Jagain" => "jagain@icloud.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "http://github.com/JagainChen/JagainLocationSelectView/CGHSelectView.git", :tag => "#{s.version}" }
  s.source_files  = 'CGHSelectView/CGHSelectView.h'
  s.framework  = "UIKit"
  s.dependency "Masonry", "~> 1.1.0"
end
