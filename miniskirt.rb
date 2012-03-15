require 'active_support/inflector'
require 'active_support/core_ext/hash'
# Factory girl, relaxed.
#
#   Factory.define :user do |f|
#     f.login 'johndoe%d'                          # Sequence.
#     f.email '%{login}@example.com'               # Interpolate.
#     f.password f.password_confirmation('foobar') # Chain.
#   end
#
#   Factory.define :post do |f|
#     f.user { Factory :user }                     # Blocks, if you must.
#   end
class Miniskirt < Struct.new(:__name__, :__klass__, :__parent__, :__attrs__)
  undef_method *instance_methods.grep(/^(?!__|object_id)/)
  private_class_method :new # "Hide" constructor from world

  # Do not use class variable, as it will be shared among all childrens and
  # can be unintentionally changed.
  @factories = {}
  @sequence = Hash.new(0)

  class << self
    # Define new factory with given name. New instance of Miniskirt
    # will be passed as argument to given block.
    #
    # Options are:
    # * class - name of class to be instantiated. By default is same as name
    # * parent - name of parent factory
    def define(name, options = {})
      name = name.to_s

      # Get class name from options or use name
      klass = options.delete(:class) { name }
      parent = options.delete(:parent)

      factory = new(name, klass, parent, {})

      yield factory

      @factories[name] = factory
    end

    # Initialize and setup class from factory.
    #
    # You can override default factory settings, by passing them
    # as second argument.
    def build(name, attrs = {})
      factory = @factories[name.to_s]

      klass, parent, attributes = [:__klass__, :__parent__, :__attrs__].inject([]) {|acc, m| acc << factory.__send__(m)}

      # Create copy of attributes
      attributes = attributes.dup

      # If parent set, then merge parent template with current template
      if parent
        parent = parent.to_s
        attributes = @factories[parent].__attrs__.dup.merge(attributes)
        klass = @factories[parent].__klass__
      end

      attributes.merge!(attrs)
      attributes.symbolize_keys!

      # Interpolate attributes
      attributes.each do |name, value|
        attributes[name] = value.sub(/%\d*d/) {|d| d % sequence(klass) } % attributes if value.kind_of? String
      end

      # Convert klass to real Class
      klass = klass.is_a?(Class) ? klass : klass.to_s.classify.constantize

      klass.new do |record|
        attributes.each do |name, value|
          record.send(:"#{name}=", (value.kind_of?(Proc) ? value.call(record) : value).dup)
        end
      end
    end

    # Create and save new factory product
    def create(name, attrs = {})
      build(name, attrs).tap { |record| record.save! }
    end

    # Return next sequence for given class
    def sequence(klass)
      @sequence[klass] += 1
    end
  end

  # Capture method calls, and save it to factory attributes
  def method_missing(name, value = nil, &block)
    __attrs__.merge!(name => block || value)
    value # Return value to be able to use chaining like: f.password f.password_confirmation("something")
  end
end

# Shortcut to Miniskirt#create
def Miniskirt(name, attrs = {})
  Miniskirt.create(name, attrs)
end

unless Object.const_defined? :Factory
  Factory = Miniskirt
  alias Factory Miniskirt
end