module ElasticORM
  class Model

    def initialize()
      @filters = []
    end

    def where **kwargs
      return self if kwargs.empty?
      kwargs.each do |key, value|
        if value.is_a? Range
          filter = filter_range(key, value)
        elsif value.is_a? Array
          filter = filter_or(key, value)
        elsif value.is_a? Array
          filter = filter_or(key, value)
        elsif value.nil?
          filter = filter_exists(key, value, must_not: true)
        else
          filter = filter_and(key, value)
        end
        add_filter(filter)
      end
      self
    end

    def not **kwargs
      kwargs.each do |key, value|
        if value.is_a? Range
          filter = not_filter(filter_range(key, value))
        elsif value.is_a? Array
          filter = not_filter(filter_or(key, value))
        elsif value.is_a? Array
          filter = not_filter(filter_or(key, value))
        elsif value.nil?
          filter = filter_exists(key, value)
        else
          filter = not_filter(filter_and(key, value))
        end
        add_filter(filter)
      end
      self
    end

    def to_query
      {bool: {filter: @filters}}
    end

    private
      def add_filter filter
        @filters.push filter
      end

      def not_filter filter
        {bool: {must_not: filter}}
      end

      def filter_and key, value
        {term: {key => value}}
      end

      def filter_or key, value
        filter_type = value.is_a?(Array) ? :terms : :term
        {bool: {filter: {filter_type => { key => value }}}}
      end

      def filter_range key, value
        {range: {key => {gte: value.first, lte: value.last}}}
      end

      def filter_exists key, value, must_not: false
        filter_type = must_not ? :must_not : :filter
        {bool: {filter_type => {exists: {field: key}}}}
      end
  end
end