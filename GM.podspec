Pod::Spec.new do |s|
  s.name         = "GM"
  s.version      = "0.1.8"
  s.summary      = "A package for develop ios application"
  s.homepage     = "https://github.com/shaokui-gu/GM"
  s.license      = 'MIT'
  s.author       = { 'gushaokui' => 'gushaoakui@126.com' }
  s.source       = { :git => "https://github.com/shaokui-gu/GM.git" }
  s.source_files = 'Sources/*.swift'
  s.resource_bundles = {
    'GM' => ['Assets/*']
  }
  s.swift_versions = ['5.2', '5.3', '5.4']
  s.dependency 'OpenUDID'
  s.requires_arc = true
end
