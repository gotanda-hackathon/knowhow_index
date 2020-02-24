# frozen_string_literal: true

User.seed(:id,
          { id: 1,
            name: Rails.application.credentials.admin[:name],
            email: Rails.application.credentials.admin[:email],
            password: Rails.application.credentials.admin[:password],
            grader: true,
            administrator: true,
            company: Company.find_by(name: 'ワンスター') },
          { id: 2,
            name: Rails.application.credentials.user[:name],
            email: Rails.application.credentials.user[:email],
            password: Rails.application.credentials.user[:password],
            grader: true,
            administrator: false,
            company: Company.find_by(name: 'アスニカ') })
