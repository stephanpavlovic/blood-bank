require 'minitest/autorun'
require 'json-schema'
require 'json'

schema_file = File.join(File.dirname(File.expand_path(__FILE__)) , 'schema', 'event.json')
events_path = File.join(File.dirname(File.expand_path(__FILE__)) , 'events')
schema = File.open(schema_file) { |f| JSON.parse(f.read) }

describe 'events' do
  Dir["#{events_path}/*\.*"].each do |file|
    it "#{file.sub(/(\..*$)/,'').sub(/^#{events_path}/,'')} contains valid json" do
      
      begin
        json_str = File.open(file) { |f| f.read }
        # force_encoding only available in ruby 1.9.2
        event = JSON.parse( json_str.respond_to?(:force_encoding ) ? json_str.force_encoding('UTF-8') : json_str)['event']
        JSON::Validator.validate!(schema, event, :version=> :draft3 )
      rescue JSON::Schema::ValidationError => schema_error
         assertion = false, schema_error.message + "\nIn: #{file}\nplease fix this!"
      rescue JSON::ParserError => parser_error
         assertion = false, parser_error.message
      else
         assertion = true
      end

      assert *assertion
    end
  end
end
