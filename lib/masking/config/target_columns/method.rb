Dir[Pathname(__FILE__).dirname.join("method/*.rb").to_s].each(&method(:require))

module Masking
  module Config
    class TargetColumns
      class Method
        def initialize(method)
          MAPPING[method.class.name].new(method)
        end

        private

        MAPPING = {
          'String'   => String,
          'Integer'  => Integer,
          'Float'    => Float,
          'Time'     => Time,
          'NilClass' => Null
        }.freeze
      end
    end
  end
end
