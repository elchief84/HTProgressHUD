Pod::Spec.new do |s|
  s.name         = "HTProgressHUD"
  s.version      = "1.0.5"
  s.summary      = "**JTProgressHUD** is the new **HUD** designed to show **YOUR** views in the **HUD style** **with one line of code**."

  s.description  = <<-DESC
                   **HDProgressHUD** is only a fork of **JTProgressHUD** with a custom animation.
                   DESC

  s.homepage     = "https://github.com/elchief84/HTProgressHUD"
  s.screenshots  = "https://raw.githubusercontent.com/kubatruhlar/JTProgressHUD/master/Screens/preview.png"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author    = "Vincenzo Romano"
  s.social_media_url   = "http://kubatruhlar.cz"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/elchief84/HTProgressHUD.git", :tag => "1.0.6" }
  s.source_files  = "HTProgressHUD/*"
  s.framework  = "UIKit"
  s.requires_arc = true
end
