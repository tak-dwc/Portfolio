# frozen_string_literal: true

class RequestTag < ApplicationRecord
  belongs_to :request
  belongs_to :tag
end
