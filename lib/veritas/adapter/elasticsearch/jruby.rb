module Veritas
  module Adapter
    class Elasticsearch
      # JRuby specific overrides.
      class Query
        # Override implementation for jruby since it
        # cannot break on nested iterations.
        #
        # Also placing this in a seperate file to make
        # it easy to exclude this code from rcov.
        #
        # Maybe this can be removed when I accept to add the
        # raise StopIteration rescue StopIteration.
        #
        if defined?(RUBY_ENGINE) and RUBY_ENGINE == 'jruby'
          # Use class eval to hide code from metrics tools.
          # @dkubb I hear you complaing while writing this :D
          #
          # With flog I do not have the option to exclude
          # a method. So adjusting metric up here will hide a
          # badness increase in other places.
          #
          class_eval(<<-RUBY,__FILE__,__LINE__+1)
            def read(accumulator)
              bounds.each do |offset,size|
                result = execute(offset,size)
                accumulator << result
                raise StopIteration if result.size < size
              end rescue StopIteration

              self
            end
          RUBY
        end
      end
    end
  end
end
