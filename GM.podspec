Pod::Spec.new do |s|
  s.name         = "GMX"
  s.version      = "0.0.5"
  s.summary      = "A package for develop ios application"
  s.homepage     = "https://github.com/shaokui-gu/GMX"
  s.license      = 'MIT'
  s.author       = { 'gushaokui' => 'gushaoakui@126.com' }
  s.source       = { :git => "https://github.com/shaokui-gu/GMX.git" }
  s.source_files = 'Sources/*.swift'
  s.resource_bundles = {
    'GM' => ['Assets/*']
  }
  s.requires_arc = true
end
