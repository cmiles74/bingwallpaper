# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bingwallpaper/version'

Gem::Specification.new do |spec|
  spec.name          = "bingwallpaper"
  spec.version       = Bingwallpaper::VERSION
  spec.authors       = ["cmiles74"]
  spec.email         = ["twitch@nervestaple.com"]
  spec.summary       = %q{Sets your wallpaper to Bing's "Image of the Day"}
  spec.description   = %q{This script downloads the "Image of the Day" and then uses Feh or Gnome to set your desktop wallpaper. More information available at https://github.com/cmiles74/bingwallpaper/.}
  spec.homepage      = "https://github.com/cmiles74/bingwallpaper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   << "bingwallpaper"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 3.0.2'
  spec.add_dependency "nokogiri", "~> 1.12.4"
  spec.add_dependency "OptionParser", "~> 0.5.1"
  spec.add_development_dependency "bundler", "~> 2.2.27"
  spec.add_development_dependency "irb", "~> 1.3.7"
  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "pry", ">= 0.10"
  spec.add_development_dependency "pry-doc", ">= 0.6.0"
  spec.add_development_dependency "method_source", "~> 1.0"
  spec.add_development_dependency "webrick", ">= 1.5.0"
end
