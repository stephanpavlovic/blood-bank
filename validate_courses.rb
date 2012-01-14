require 'minitest/autorun'
require 'json-schema'
require 'json'

schema_file = File.join(File.dirname(File.expand_path(__FILE__)) , 'schema', 'course.json')
courses_path = File.join(File.dirname(File.expand_path(__FILE__)) , 'courses')
schema = File.open(schema_file) { |f| JSON.parse(f.read) }

describe 'courses' do
  Dir["#{courses_path}/*\.*"].each do |file|
    it "#{file.sub(/(\..*$)/,'').sub(/^#{courses_path}/,'')} contains valid json" do
      
      begin
        json_str = File.open(file) { |f| f.read }
        # force_encoding only available in ruby 1.9.2
        course = JSON.parse( json_str.respond_to?(:force_encoding ) ? json_str.force_encoding('UTF-8') : json_str)['course']
        JSON::Validator.validate!(schema, course, :version=> :draft3 )
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
