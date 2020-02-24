# frozen_string_literal: true

User.seed do |s|
  s.id = 1
  s.name = Rails.application.credentials.admin[:name]
  s.email = Rails.application.credentials.admin[:email]
  s.password = Rails.application.credentials.admin[:password]
  s.grader = true
  s.administrator = true
  s.company = Company.find_by(name: 'ワンスター')
end
