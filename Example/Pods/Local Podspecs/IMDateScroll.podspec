Pod::Spec.new do |s|
  s.name             = "IMDateScroll"
  s.version          = "0.1.0"
  s.summary          = "A short description of IMDateScroll."
  s.description      = <<-DESC
                       An optional longer description of IMDateScroll

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/IMcD23/IMDateScroll"
  s.license          = 'MIT'
  s.author           = { "Ian McDowell" => "mcdow.ian@gmail.com" }
  s.source           = { :git => "https://github.com/IMcD23/IMDateScroll.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ian_mcdowell'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
end
