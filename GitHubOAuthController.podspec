
Pod::Spec.new do |s|

  s.name         = "GitHubOAuthController"
  s.version      = "0.3.0"
  s.summary      = "Simple GitHub OAuth Controller with 1Password support"

  s.homepage     = "https://github.com/friedbunny/GitHubOAuthController"

  s.license      = { :type => "MIT", :file => "LICENSE" }
 
  s.author             = { "dkhamsing" => "dkhamsing8@gmail.com" }
  s.social_media_url   = "http://twitter.com/dkhamsing" 

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/friedbunny/GitHubOAuthController.git", :tag => s.version.to_s }
 
  s.source_files  = "GitHubOAuthController/*"
   
  s.requires_arc = true

  s.dependency "1PasswordExtension", "~> 1.8"

end
