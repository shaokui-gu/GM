Pod::Spec.new do |s|
  s.name         = "GM"
  s.version      = "0.0.5"
  s.summary      = "A package for develop ios application"
  s.homepage     = "https://github.com/shaokui-gu/GM"
  s.license      = 'MIT'
  s.author       = { 'gushaokui' => 'gushaoakui@126.com' }
  s.source       = { :git => "https://github.com/shaokui-gu/GM.git" }
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end