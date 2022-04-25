require 'time'
require './errors'

module NASA
  module Api
    class InputParser
      attr_reader :args

      def initialize(args)
        @args = args
        @errors = {
          arg_names: []
        }
      end

      def parse
        parsed = Hash[split_args]
        raise invalid_arg_names unless @errors[:arg_names].empty?
        return { help: true } if parsed.dig(:help)
        default_required_args.merge(parsed)
      end

      private

      ALLOWED_ARGS = [:rover, :cam, :asof, :days, :h, :help]

      def default_required_args
        { asof: Time.new, days: 10 }
      end

      def split_args
        args.map do |arg|
          name, value = arg.split('=')
          parse_argument(name, value)
        end
      end

      def add_name_error(name)
        @errors[:arg_names] << name
      end

      def parse_argument(name, value)
        name = remove_trailing_dashes(name)
        add_name_error(name) unless valid_arg_name?(name)
        value = send("parse_#{name}", value)
        [name.to_sym, value]
      end

      def remove_trailing_dashes(name)
        name.gsub(/--(\w+)/,'\1')
      end

      def parse_help(_value)
        true
      end
      alias :parse_h :parse_help

      def parse_asof(date)
        Time.parse(date)
      end

      def parse_days(days)
        days.to_i
      end

      def valid_arg_name?(name)
        ALLOWED_ARGS.include?(name.to_sym)
      end

      def invalid_arg_names
        raise BadInputError.new(details: {
          invalid_arguments: @errors[:arg_names]
        })
      end

      def method_missing(m, *args)
        return args.first if m.to_s.start_with?('parse_')
        super
      end
    end
  end
end

