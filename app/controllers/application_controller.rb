# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_member!,except: [:top]

  before_action :set_tags
  # sidebar用の記述
  def set_tags
    @set_tags = Tag.joins("INNER JOIN request_tags ON request_tags.tag_id = tags.id INNER JOIN requests ON request_tags.request_id = requests.id")
    .where('requests.is_active': 0).group('tags.id').select('tags.*','COUNT("tags.id") as count')
  end
end
