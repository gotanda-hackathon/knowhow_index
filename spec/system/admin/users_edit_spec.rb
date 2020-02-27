# frozen_string_literal: true

require 'rails_helper'

describe '管理画面：アカウント編集', type: :system do
  context 'ログインしているとき' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      sign_in_as(login_user)
      visit admin_users_path
    end

    context '権限が not_administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_administrator) }

      it_behaves_like 'トップページにリダイレクト'
    end

    context '権限が administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :administrator) }

      context '正しく入力するとき' do
        before do
          within "#edit_btn_#{user.id}" do
            click_on '編集'
          end
          page.find('h5', text: 'アカウント編集', match: :first)
          fill_in '氏名', with: '編集テストアカウント'
          fill_in 'メールアドレス', with: 'edit@example.com'
          click_on '更新する'
        end

        it '情報を編集・更新できること' do
          aggregate_failures do
            expect(page).to have_current_path edit_admin_user_path(user)
            expect(page).to have_css '.green.lighten-4'
            expect(page).to have_content '更新いたしました'
            expect(page).to have_field '氏名', with: '編集テストアカウント'
            expect(page).to have_field 'メールアドレス', with: 'edit@example.com'
          end
        end
      end

      context '値を空にするとき' do
        before do
          within "#edit_btn_#{user.id}" do
            click_on '編集'
          end
          page.find('h5', text: 'アカウント編集', match: :first)
          fill_in '氏名', with: ''
          click_on '更新する'
        end

        it '情報を更新できずエラーが出ること' do
          aggregate_failures do
            expect(page).to have_css '.red.lighten-4'
            expect(page).to have_content '更新に失敗しました'
          end
        end
      end
    end
  end

  context 'ログインしていないとき' do
    before do
      visit admin_users_path
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end
end
