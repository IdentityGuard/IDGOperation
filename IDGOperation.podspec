Pod::Spec.new do |s|
  s.name             = 'IDGOperation'
  s.version          = '0.1.0'
  s.summary          = 'Async Extension for NSOperation.'
  s.homepage         = 'https://github.com/IdentityGuard/IDGOperation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mojtabacazi' => 'mojtabacazi@gmail.com' }
  s.source           = { :git => 'https://github.com/IdentityGuard/IDGOperation.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'IDGOperation/Classes/**/*'
end
