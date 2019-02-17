# frozen_string_literal: true

module Searcher
  module Serializers
    # Provides a basic serialization functional for specifying list of hash keys for serialization
    # A minimal implementation could be:
    #
    # class MySerializer < Base
    #   attributes :name, :street
    # end
    #
    # user = { name: 'Vasya', surname: 'Pupkin', address: { city: 'Moscow', street: 'Lenina'}}
    # MySerializer.new(user).serializable_hash => {name: 'vasia', street: 'Lenina'}
    class Base
      class << self
        attr_accessor :_attributes

        def attributes(*attr)
          self._attributes ||= []
          self._attributes |= attr
        end
      end

      attr_accessor :serializable_hash

      def initialize(object)
        self.serializable_hash = filter_hash(object)
      end

      def to_json
        serializable_hash.to_json
      end

      private

      def filter_hash(hash)
        results = hash.slice(*self.class._attributes)
        hash.each do |_k, v|
          results.merge!(filter_hash(v)) if v.instance_of?(Hash)
        end
        results
      end
    end
  end
end
