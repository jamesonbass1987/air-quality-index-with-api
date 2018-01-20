
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "air-quality-index-with-api/version"

Gem::Specification.new do |spec|
  spec.name          = "air-quality-index-with-api"
  spec.version       = AirQualityIndexWithApi::VERSION
  spec.authors       = ["jamesonbass1987"]
  spec.email         = ["jamesonbass@gmail.com"]

  spec.summary       = %q{A gem that retrieves local air quality index information using the AirNow.gov API.}
  spec.homepage      = "github.com/jamesonbass1987/air-quality-index-with-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
