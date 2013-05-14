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
class Miniskirt < Struct.new(:__klass__)
  undef_method *instance_methods.grep(/^(?!__|object_id)/)
  @@attrs = {} and private_class_method :new

  class << self
    def define name, options = {}
      @@attrs[name = name.to_s] = [{}, options] and yield new(name)
    end

    def build name, attrs = {}
      (h, opts, n = @@attrs[name = name.to_s]) and m = opts[:class] || name
      p = opts[:parent] and (h, m = @@attrs[p = p.to_s][0].merge(h), p)
      (m = m.is_a?(Class) ? m : m.to_s.camelize.constantize).new.tap do |r|
        attrs.symbolize_keys!.reverse_update(h).each do |k, v|
          r.send "#{k}=", case v when String # Sequence and interpolate.
            v.sub(/%\d*d/) {|d| d % n ||= self.incr} % attrs % n
          when Proc then v.call(r) else v
          end
        end
      end
    end

    def create name, attrs = {}
      build(name, attrs).tap { |record| record.save! }
    end

    def incr
      @count ||= 1
      @count += 1
    end
  end

  def method_missing name, value = nil, &block
    @@attrs[__klass__][0][name] = block || value
  end
end

def Miniskirt name, attrs = {}
  Miniskirt.create(name, attrs)
end

unless Object.const_defined? :Factory
  Factory = Miniskirt
  alias Factory Miniskirt
end
