Pod::Spec.new do |s|

    s.name             = "DisplaySwitcher"
    s.version          = "2.0"
    s.swift_version = '5.0'
    s.summary          = "This component implements custom transition between two collection view layouts."
    s.screenshot       = 'https://d13yacurqjgara.cloudfront.net/users/116693/screenshots/2276068/open-uri20151005-3-walc59'

    s.homepage         = "https://github.com/Yalantis/DisplaySwitcher"
    s.license          = { :type => "MIT", :file => "LICENSE" }
    s.author           = "Yalantis"
    s.social_media_url = "https://twitter.com/yalantis"
    
    
    s.ios.deployment_target = '8.0'
    
    s.source           = { :git => "https://github.com/Yalantis/DisplaySwitcher.git", :tag => s.version }
    s.source_files     = 'Pod/Classes/**/*'

    s.requires_arc     = true

end
