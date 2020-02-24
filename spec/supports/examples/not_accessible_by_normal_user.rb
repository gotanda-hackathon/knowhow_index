# frozen_string_literal: true

RSpec.shared_examples 'トップページにリダイレクト' do
  it 'トップページにリダイレクトされること' do
    aggregate_failures do
      expect(page).to have_current_path root_path
      expect(page).to have_css '.red.lighten-4'
      expect(page).to have_content '権限がありません'
    end
  end
end
