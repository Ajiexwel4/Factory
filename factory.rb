# Factory insteed Struct
class Factory
  def self.new(*keys, &block)
    Class.new do
      attr_accessor(*keys)
      define_method 'initialize' do |*values|
        keys.each_with_index do |key, i|
          instance_variable_set("@#{key}", values[i])
        end
      end

      def [](arg)
        arg = instance_variables[arg][1..-1] if arg.is_a? Numeric
        instance_variable_get("@#{arg}")
      end

      def to_s
        "#<factory #{self.class}"
        instance_variables.each do |var|
          " #{var[1..-1]}=" + '"' + instance_variable_get(var).to_s + '"'
        end
      end

      class_eval(&block) if block_given?
    end
  end
end

# Tests
puts 'Test 1'
p User1 = Factory.new(:name, :address, :zip)
p op = User1.new('Dave', '123 Main', 231)
p op.name
p op['name']
p op[:name]
p op[0]

puts 'Test 2'
User2 = Factory.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end
p User2.new('Dave', '123 Main').greeting # => "Hello Dave!"
