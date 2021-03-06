Pod::Spec.new do |s|
  s.name             = 'YXWebBrowser'
  s.version          = '0.1.0'
  s.summary          = 'A web browser for iOS.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://0.0.0.0:3000/wyx/YXWebBrowser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sternapara' => 'yxuan426@163.com' }
  s.source           = { :git => 'http://localhost:3000/wyx/YXWebBrowser.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.source_files = 'YXWebBrowser/Classes/**/*.{h,m}'
  s.resources    = 'YXWebBrowser/Assets/YXWebBrowser.bundle'

  s.dependency 'RegExCategories', '~> 1.0'
  s.dependency 'NJKWebViewProgress', '~> 0.2.3'

  s.subspec 'NavigationBar' do |ss|
    ss.source_files = 'YXWebBrowser/Classes/NavigationBar/*.{h,m}'
  end

  s.subspec 'ProgressView' do |ss|
    ss.source_files = 'YXWebBrowser/Classes/ProgressView/*.{h,m}'
  end

  s.subspec 'WebBrowser' do |ss|
    ss.dependency 'YXWebBrowser/NavigationBar'
    ss.dependency 'YXWebBrowser/ProgressView'
    ss.source_files = 'YXWebBrowser/Classes/WebBrowser/*.{h,m}'
  end

end
