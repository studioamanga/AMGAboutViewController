Pod::Spec.new do |s|

  s.name = "AMGSettingsViewController"
  s.version = "0.1"
  s.summary = "AMGSettingsViewController..."

  s.description = <<-DESC
                   `AMGSettingsViewController`...
                   DESC

  s.homepage = "https://github.com/studioamanga/AMGSettingsViewController"
  s.license = 'MIT'
  s.author = { "Vincent Tourraine" => "me@vtourraine.net" }
  s.social_media_url = "http://twitter.com/AMGSettingsViewController"

  s.platform = :ios, '9.0'
  s.source = { :git => "https://github.com/studioamanga/AMGSettingsViewController.git", :tag => "0.1" }
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.requires_arc = true

  s.dependency 'SVProgressHUD'
  s.dependency 'AMGAppButton'
  s.dependency 'VTAppButton'
  s.dependency 'NGAParallaxMotion'
  s.dependency 'VTAcknowledgementsViewController'

end
