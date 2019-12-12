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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', ['>= 4.2.0', '<= 5.2.3']
  spec.add_dependency 'spreadsheet', '~> 1.0'
end
