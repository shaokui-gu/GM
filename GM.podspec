Pod::Spec.new do |s|
  s.name         = "GMX"
  s.version      = "0.0.4"
  s.summary      = "A package for develop ios application"
  s.homepage     = "https://github.com/shaokui-gu/GMX"
  s.license      = 'MIT'
  s.author       = { 'gushaokui' => 'gushaoakui@126.com' }
  s.source       = { :git => "https://github.com/shaokui-gu/GMX.git" }
  s.source_files = 'Sources/*.swift'
  s.resource_bundles = {
    'GM' => ['Assets/*']
  }
  s.swift_versions = ['5.2', '5.3', '5.4']
  s.dependency 'OpenUDID'
  s.dependency 'MBProgressHUD'
  s.requires_arc = true
end
