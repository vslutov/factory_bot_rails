class FactoryGirlGenerator < Rails::Generators::NamedBase
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
  class_option :file, :type => :string, :default => "test/factories.rb", :desc => "The file where factory definitions go."

  def create_fixture_file
    define_line      = "Factory.define :#{singular_name} do |factory|"
    attributes_lines = attributes.map {|a| "  factory.#{a.name} { #{a.default.inspect} }" }.join('\n')

    create_file options[:file]
    append_file options[:file], "#{define_line}\n#{attributes_lines}\nend"
  end

  hook_for :fixture_replacement
end
