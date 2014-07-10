# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cia/s3/utils/version'

Gem::Specification.new do |spec|
  spec.name          = "cia-s3-utils"
  spec.version       = Cia::S3::Utils::VERSION
  spec.authors       = ["chrhsmt"]
  spec.email         = ["chr@chrhsmt.com"]
  spec.summary       = %q{aws s3 utilites cia.jp spcial.}
  spec.description   = %q{aws s3 utilites cia.jp spcial.}
  spec.homepage      = "https://github.com/ciajp/cia-s3-utils"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.6"
  spec.add_dependency "rake"
  spec.add_dependency "byebug"
  spec.add_dependency 'mime-types'
  spec.add_dependency "actionpack"
  spec.add_dependency 'activesupport'
  spec.add_dependency 'rubyzip'
  spec.add_dependency 'aws-sdk'

end
