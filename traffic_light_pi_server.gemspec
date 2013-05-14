# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "traffic_light_pi_server"
  spec.version       = "0.0.2"
  spec.authors       = ["Nicolas Ledez"]
  spec.email         = ["rubygems@ledez.net"]
  spec.description   = %q{A traffic light serveur for Raspberry π}
  spec.summary       = %q{Get a Raspberry π & traffic light install this app on π & enjoy}
  spec.homepage      = "https://github.com/nledez/traffic_light_pi_server"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"
  spec.add_dependency "haml"
  spec.add_dependency "wiringpi" if spec.platform.to_s == 'arm-linux-eabihf'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"

  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-bundler"

  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "json", '~> 1.7.7'
  spec.add_development_dependency "coveralls"

  if spec.platform.to_s == 'arm-linux-eabihf'
    spec.add_development_dependency "rb-fsevent"
    spec.add_development_dependency "growl"
  end
end
