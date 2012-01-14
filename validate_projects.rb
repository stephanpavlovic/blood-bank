require 'minitest/autorun'
require 'json-schema'
require 'json'

schema_file = File.join(File.dirname(File.expand_path(__FILE__)) , 'schema', 'project.json')
projects_path = File.join(File.dirname(File.expand_path(__FILE__)) , 'projects')
schema = File.open(schema_file) { |f| JSON.parse(f.read) }

describe 'projects' do
  Dir["#{projects_path}/*\.*"].each do |file|
    it "#{file.sub(/(\..*$)/,'').sub(/^#{projects_path}/,'')} contains valid json" do
      
      begin
        json_str = File.open(file) { |f| f.read }
        # force_encoding only available in ruby 1.9.2
        project = JSON.parse( json_str.respond_to?(:force_encoding ) ? json_str.force_encoding('UTF-8') : json_str)['project']
        JSON::Validator.validate!(schema, project, :version=> :draft3 )
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
