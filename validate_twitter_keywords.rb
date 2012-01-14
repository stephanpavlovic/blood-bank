require 'minitest/autorun'
require 'json-schema'
require 'json'

schema_file = File.join(File.dirname(File.expand_path(__FILE__)) , 'schema', 'twitter_keyword.json')
twitterkeywords_path = File.join(File.dirname(File.expand_path(__FILE__)) , 'twitter_keywords')
schema = File.open(schema_file) { |f| JSON.parse(f.read) }

describe 'keywords' do
  Dir["#{twitterkeywords_path}/*\.*"].each do |file|
    it "#{file.sub(/(\..*$)/,'').sub(/^#{twitterkeywords_path}/,'')} contains valid json" do
      
      begin
        json_str = File.open(file) { |f| f.read }
        # force_encoding only available in ruby 1.9.2
        twitter_keywords = JSON.parse( json_str.respond_to?(:force_encoding ) ? json_str.force_encoding('UTF-8') : json_str)
        JSON::Validator.validate!(schema, twitter_keywords, :version=> :draft3 )
      rescue JSON::Schema::ValidationError => schema_error
         assertion = false, schema_error.message + "\nIn: #{file},\n please fix this!"
      rescue JSON::ParserError => parser_error
         assertion = false, parser_error.message
      else
         assertion = true
      end

      assert *assertion
    end
  end
end

