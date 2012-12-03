module Genome
  module Extensions
    module HTTPStatus
      class BadRequest < Exception
      end

      class NotFound < Exception
      end
    end
  end
end
