module Genome
  module Extensions
    module HasCacheableQuery
      extend ActiveSupport::Concern

      included do
        private
        #when a new class method is added, see if it is one that has been
        #registered as cacheable, if so, redefine to wrap the caching logic
        def self.singleton_method_added(method_name)
          if(cache_key = (@cached_methods || {}).delete(method_name))
            rewrite_method(method_name, cache_key)
          end
        end

        #if the method exists, rewrite it immediately, otherwise
        #register a method name (and associated cache key) to be cached
        def self.cache_query(method_name, cache_key)
          if respond_to? method_name
            rewrite_method(method_name, cache_key)
          else
            (@cached_methods ||= {})[method_name] = cache_key
          end
        end

        #capture the old method, define a new method to overwrite
        #the existing one, surrounding the original in
        #caching logic
        def self.rewrite_method(method_name, cache_key)
          old_method = method(method_name)
          define_singleton_method(method_name) do |*args|
            cache_key_with_args = "#{cache_key}.#{args.to_s}"
            Rails.cache.fetch(cache_key_with_args) { old_method.call(*args) }
          end
        end
      end

    end
  end
end