# frozen_string_literal: true

require 'rails_helper'

describe '管理画面：アカウント一覧', type: :system do
  context 'ログインしているとき' do
    let!(:users) { FactoryBot.create_list(:user, 2) }

    before do
      sign_in_as(login_user)
      visit admin_users_path
    end

    context '権限が not_administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_administrator) }

      it_behaves_like '権限が弱いこと'
    end

    context '権限が administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :administrator) }

      it 'アカウントが表示されていること' do
        expect_outline_of(users[0])
        expect_outline_of(users[1])
        expect_outline_of(login_user)
      end

      it '編集ボタンがアカウントの数だけあること' do
        expect(page).to have_content('編集', count: User.all.count)
      end

      it '削除ボタンがアカウントの数だけあること' do
        expect(page).to have_content('削除', count: User.all.count)
      end
    end
  end

  context 'ログインしていないとき' do
    before do
      visit admin_users_path
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end

  def expect_outline_of(user)
    within "#user_#{user.id}" do
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content user.company.name
      expect(page).to have_content(user.grader? ? 'あり' : 'なし')
      expect(page).to have_content(user.administrator? ? 'あり' : 'なし')
    end
  end
end
