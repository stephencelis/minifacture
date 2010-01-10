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
class Miniskirt < Struct.new(:klass)
  @@factories = {} and private_class_method :new
  class << self
    def define(name)
      @@factories[name = name.to_s] = {} and yield new(name)
    end

    def build(name, attrs = {})
      name = name.to_s and (mod = name.classify.constantize).new do |record|
        attrs.stringify_keys!.reverse_update(@@factories[name]).each do |k, v|
          record.send "#{k}=", case v when String # Sequence and interpolate.
            v.sub(/%\d*d/) { |n| n % @n ||= mod.maximum(:id).to_i + 1 } %
              attrs % @n
          when Proc then v.call(record) else v
          end
        end
      end
    ensure
      @n = nil
    end

    def create(name, attrs = {})
      build(name, attrs).tap { |record| record.save }
    end
  end

  def method_missing(name, value = nil, &block)
    @@factories[klass][name] = block || value
  end
end

def Miniskirt(name, attrs = {})
  Miniskirt.create(name, attrs)
end

Factory = Miniskirt
alias Factory Miniskirt