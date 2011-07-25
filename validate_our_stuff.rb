require 'minitest/autorun'
require 'json-schema'
require 'json'

SCHEMA_FILE = File.join(File.dirname(File.expand_path(__FILE__)) , 'schema', 'our_stuff.json')
OURSTUFF_PATH = File.join(File.dirname(File.expand_path(__FILE__)) , 'our_stuff')
schema = File.open(SCHEMA_FILE) { |f| JSON.parse(f.read) }

describe 'our_stuff' do
  Dir["#{OURSTUFF_PATH}/*\.*"].each do |file|
    it "#{file.sub(/(\..*$)/,'').sub(/^#{OURSTUFF_PATH}/,'')} contains valid json" do
      
      
      begin
        json_str = File.open(file) { |f| f.read }
        # force_encoding only available in ruby 1.9.2
        ourstuff = JSON.parse( json_str.respond_to?(:force_encoding ) ? json_str.force_encoding('UTF-8') : json_str)['ourstuff']
        JSON::Validator.validate!(schema, ourstuff, :version=> :draft3 )
      rescue JSON::Schema::ValidationError => schema_error
         assertion = false, schema_error.message + "\nIn: #{file}\n[#{ourstuff['created_by']}, please fix this and send another pull request!]"
      rescue JSON::ParserError => parser_error
         assertion = false, parser_error.message
      else
         assertion = true
      end

      assert *assertion
    end
  end
end

