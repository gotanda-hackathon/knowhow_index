# frozen_string_literal: true

RSpec.shared_examples 'ログイン画面にリダイレクト' do
  it 'ログイン画面にリダイレクトすること' do
    aggregate_failures do
      expect(page).to have_current_path login_path
      expect(page).to have_css '.red.lighten-4'
      expect(page).to have_content 'ログインが必要です'
    end
  end
end
