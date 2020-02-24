# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def show_grader
    grader ? 'あり' : 'なし'
  end

  def show_administrator
    administrator ? 'あり' : 'なし'
  end
end
