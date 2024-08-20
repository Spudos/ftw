module Match
  module MatchEnd
    class DataStructure
      def initialize
        @data = {}
      end

      def add_information_point(minute, details = {})
        @data[minute] = details
      end

      def club_popularity(minute)
        @data[minute][0][4]
      end
    end
  end
end
