# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'japanese_syllabary/version'

Gem::Specification.new do |spec|
  spec.name          = "japanese_syllabary"
  spec.version       = JapaneseSyllabary::VERSION
  spec.authors       = ["o-sawa"]
  spec.email         = ["osawa@val.co.jp"]
  spec.summary       = %q{日本語の五十音を取得}
  spec.description   = %q{日本語の五十音を行ごとに取得するメソッドです}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
