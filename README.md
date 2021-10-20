# Poorman's Export
Poorman's Export is a simple but powerful CSV and XLS exporter.

## Usage
Poorman's Export transforms a collection of objects into a CSV or a XLS file that can be sent to the browser just like this:
```ruby
def index
  @collection = Article.all
  fields_to_export = %i[id title body created_at published_at]

  respond_to do |format|
    format.html
    format.csv do
      send_data(
        PoormansExport::Exporter.new(@collection, fields_to_export).csv_string,
        type: 'text/csv; charset=utf-16le; header=present',
        disposition: 'attachment',
        filename: 'articles.csv'
      )
    end
    format.xls do
      send_data(
        PoormansExport::Exporter.new(@collection, fields_to_export).xls_string,
        type: 'application/xls',
        disposition: 'attachment',
        filename: 'articles.xls'
      )
    end
  end
end
```

Poorman's Export will process the collection and convert its fields into something readable by a human, automatically processing dates, times, booleans and even relations, by using the `to_s` method of the related object.

### Custom headers

By default, Poorman's Export will extract the localized name of each of the fields of the exportation for its header by using `human_attribute_name`. You can override this behavior by adding an extra parameter in the constructor with your own custom headers:

```ruby
PoormansExport::Exporter.new(@collection, ['full_name', 'date_of_birth', 'city_name'], ['Name', 'Birthday', 'City'])
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'poormans_export'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install poormans_export
```

After installing the gem, register the CSV and XLS MIME types in your application by adding these lines to your `config/initializers/mime_types.rb` file:
```ruby
Mime::Type.register 'text/csv; charset=utf-16le; header=present', :csv
Mime::Type.register 'application/xls', :xls
```

And you're good to go!

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
