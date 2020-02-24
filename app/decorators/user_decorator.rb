# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def show_grader
    if grader
      helpers.content_tag(:span, 'あり', class: 'badge orange white-text')
    else
      helpers.content_tag(:span, 'なし', class: 'badge grey white-text')
    end
  end

  def show_administrator
    if administrator
      helpers.content_tag(:span, 'あり', class: 'badge orange white-text')
    else
      helpers.content_tag(:span, 'なし', class: 'badge grey white-text')
    end
  end
end
