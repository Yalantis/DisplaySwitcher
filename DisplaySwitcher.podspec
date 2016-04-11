Pod::Spec.new do |s|

    s.name             = "DisplaySwitcher"
    s.version          = "0.1.0"
    s.summary          = "This component implements custom transition between two collection view layouts."
    s.screenshot       = 'https://d13yacurqjgara.cloudfront.net/users/116693/screenshots/2276068/open-uri20151005-3-walc59'

    s.homepage         = "https://github.com/Yalantis/DisplaySwitcher"
    s.license          = { :type => "MIT", :file => "LICENSE" }
    s.author           = "Yalantis"
    s.social_media_url = "https://twitter.com/yalantis"

    s.platform         = :ios, '9.0'
    s.ios.deployment_target = '9.0'

    s.source           = { :git => "https://github.com/Yalantis/DisplaySwitcher.git", :tag => '0.1.0' }
    s.source_files     = 'Pod/Classes/**/*'

    s.requires_arc     = true

end
