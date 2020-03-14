# frozen_string_literal: true

RSpec.shared_examples '別の企業情報にアクセスすること' do
  it '別の企業情報なので、トップページにリダイレクトされること' do
    aggregate_failures do
      expect(page).to have_current_path root_path
      expect(page).to have_css '.red.lighten-4'
      expect(page).to have_content '別の企業情報は変更できません'
    end
  end
end

RSpec.shared_examples '権限が弱いこと' do
  it '権限が弱く、トップページにリダイレクトされること' do
    aggregate_failures do
      expect(page).to have_current_path root_path
      expect(page).to have_css '.red.lighten-4'
      expect(page).to have_content '権限がありません'
    end
  end
end
