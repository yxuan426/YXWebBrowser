Pod::Spec.new do |s|
  s.name             = 'YXWebBrowser'
  s.version          = '0.1.0'
  s.summary          = 'A web browser for iOS7 and above.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yxuan426/YXWebBrowser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sternapara' => 'yxuan426@163.com' }
  s.source           = { :git => 'https://github.com/yxuan426/YXWebBrowser.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.source_files = 'YXWebBrowser/Classes/**/*'
  s.resources    = 'YXWebBrowser/Assets/YXWebBrowser.bundle'

  s.dependency 'RegExCategories', '~> 1.0'
  s.dependency 'NJKWebViewProgress', '~> 0.2.3'

end
