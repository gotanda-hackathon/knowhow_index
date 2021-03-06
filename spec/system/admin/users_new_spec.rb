# frozen_string_literal: true

require 'rails_helper'

describe '管理画面：アカウント作成', type: :system do
  context 'ログインしているとき' do
    before do
      sign_in_as(login_user)
      visit new_admin_user_path
    end

    context '権限が not_administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_administrator) }

      it_behaves_like '権限が弱いこと'
    end

    context '権限が administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :administrator) }

      context '正しく入力するとき' do
        before do
          fill_in '氏名', with: '新規作成テストアカウント'
          fill_in 'メールアドレス', with: 'new_create@example.com'
          fill_in 'パスワード', with: '123'
          fill_in 'パスワード（確認用）', with: '123'
          find('div.select-wrapper input', text: '').click
          find('div.select-wrapper li span', text: Company.first.name).click
          find('label', text: '採点者権限').click
          find('label', text: '管理者権限').click
          click_on '登録する'
        end

        it '情報を作成できること' do
          user = User.last
          aggregate_failures do
            expect(page).to have_current_path admin_users_path
            expect(page).to have_css '.green.lighten-4'
            expect(page).to have_content '登録いたしました'
            expect(page.all('tbody tr').last).to have_content user.name
            expect(page.all('tbody tr').last).to have_content user.email
            expect(page.all('tbody tr').last).to have_content user.company.name
            expect(page.all('tbody tr').last).to have_content(user.grader? ? 'あり' : 'なし')
            expect(page.all('tbody tr').last).to have_content(user.administrator? ? 'あり' : 'なし')
          end
        end
      end

      context '何も入力しないとき' do
        before do
          click_on '登録する'
        end

        it '情報を作成できずエラーが出ること' do
          aggregate_failures do
            expect(page).to have_css '.red.lighten-4'
            expect(page).to have_content '登録に失敗しました'
          end
        end
      end
    end
  end

  context 'ログインしていないとき' do
    before do
      visit new_admin_user_path
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end
end
