# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'poormans_export/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'poormans_export'
  spec.version     = PoormansExport::VERSION
  spec.authors     = [
    'Imobach González Sosa',
    'Ignacio Aliende García',
    'Adán Alonso Salvador'
  ]
  spec.email = [
    'imobachgs@banot.net',
    'ialiendeg@gmail.com',
    'adan.alonso.s@gmail.com'
  ]
  spec.homepage    = 'https://github.com/Usabi/poormans_export'
  spec.summary     = 'A simple but powerful exporter'
  spec.description = 'Poorman\'s Export is a simple but powerful CSV and XLS exporter'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', ['>= 4.2.0']
  spec.add_dependency 'spreadsheet', '~> 1.0'
end
