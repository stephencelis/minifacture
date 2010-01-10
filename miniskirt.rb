# Factory girl, relaxed.
module Miniskirt
  mattr_reader :factories
  @@factories = {}

  class << self
    def define(name, &block)
      factories[name.to_s] = {} and yield BasicObject.new.instance_eval(%{
        def method_missing(name, value)
          ::Miniskirt.factories["#{name}"][name] = value
        end
        self
      })
    end

    def build(name, attrs = {})
      name.to_s.classify.constantize.new factories[name.to_s].merge(attrs)
    end

    def create(name, attrs = {})
      build(name, attrs).tap { |record| record.save }
    end
  end
end

def Miniskirt(name, attrs = {})
  Miniskirt.create(name, attrs)
end

Factory = Miniskirt
alias Factory Miniskirt
