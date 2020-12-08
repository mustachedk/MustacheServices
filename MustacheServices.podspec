Pod::Spec.new do |s|
    s.name             = 'MustacheServices'
    s.version          = '6.0.4'
    s.summary          = 'Helper methods used at Mustache when creating new apps.'
    s.homepage         = 'https://github.com/mustachedk/MustacheServices'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Tommy Sadiq Hinrichsen' => 'th@mustache.dk' }
    s.source           = { :git => 'https://github.com/mustachedk/MustacheServices.git', :tag => s.version.to_s }
    s.swift_version = '5.1'

    s.ios.deployment_target = '11.0'

    s.source_files = 'Sources/MustacheServices/Classes/**/*'

    s.frameworks = 'UIKit'

    s.dependency 'MustacheFoundation'
    s.dependency 'Resolver'
    #s.dependency 'KSCrash'

    s.static_framework = true

end
