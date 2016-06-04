module Pageable
  extend ActiveSupport::Concern

  module ClassMethods
    def page count: 25, offset: 0
      results = self.where(nil).offset(offset.to_i).limit(count.to_i)
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end
