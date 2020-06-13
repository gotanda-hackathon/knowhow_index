# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def show_grader
    if grader
      helpers.tag.span('あり', class: 'badge orange white-text')
    else
      helpers.tag.span('なし', class: 'badge grey white-text')
    end
  end

  def show_administrator
    if administrator
      helpers.tag.span('あり', class: 'badge orange white-text')
    else
      helpers.tag.span('なし', class: 'badge grey white-text')
    end
  end
end
