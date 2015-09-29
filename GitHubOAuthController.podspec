
Pod::Spec.new do |s|

  s.name         = "GitHubOAuthController"
  s.version      = "0.2"
  s.summary      = "Simple GitHub OAuth Controller"

  s.homepage     = "https://github.com/dkhamsing/GitHubOAuthController"

  s.license      = { :type => "MIT", :file => "LICENSE" }
 
  s.author             = { "dkhamsing" => "dkhamsing8@gmail.com" }
  s.social_media_url   = "http://twitter.com/dkhamsing" 

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/dkhamsing/GitHubOAuthController.git", :tag => s.version.to_s }
 
  s.source_files  = "GitHubOAuthController/*"
   
  s.requires_arc = true
  
end
