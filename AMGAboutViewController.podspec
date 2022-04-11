Pod::Spec.new do |s|

  s.name = "AMGAboutViewController"
  s.version = "0.3"
  s.summary = "AMGAboutViewController..."

  s.description = <<-DESC
                   `AMGAboutViewController`...
                   DESC

  s.homepage = "https://github.com/studioamanga/AMGAboutViewController"
  s.license = 'MIT'
  s.author = { "Vincent Tourraine" => "me@vtourraine.net" }
  s.social_media_url = "http://twitter.com/AMGAboutViewController"

  s.platform = :ios, '13.0'
  s.source = { :git => "https://github.com/studioamanga/AMGAboutViewController.git", :tag => "0.3" }
  s.source_files = 'Sources', 'Sources/**/*.swift'
  s.requires_arc = true

  s.dependency 'AMGAppButton'
  s.dependency 'VTAppButton'
  s.dependency 'AcknowList'

end
