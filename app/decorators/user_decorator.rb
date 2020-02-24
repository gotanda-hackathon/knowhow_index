class UserDecorator < Draper::Decorator
  delegate_all

  def show_grader
    grader ? 'あり' : 'なし'
  end

  def show_admin
    admin ? 'あり' : 'なし'
  end
end
