#
# Be sure to run `pod lib lint JCPullToRefreshView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JCPullToRefreshView"
  s.version          = "0.0.3"
  s.summary          = "Supports pull-to-refresh and pull-to-loadmore."
  s.homepage         = "http://lijingcheng.github.io/"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "lijingcheng" => "bj_lijingcheng@163.com" }
  s.source           = { :git => "https://github.com/lijingcheng/JCPullToRefreshView.git", :tag => s.version.to_s }
  s.social_media_url = 'http://weibo.com/lijingcheng1984'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.resources = ['Pod/Assets/*.png']
  s.resource_bundles = {
    'JCPullToRefreshView' => ['Pod/Assets/*.png']
  }
  s.dependency 'KVOController', '~> 1.0.3'
end
