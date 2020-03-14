# frozen_string_literal: true

require 'rails_helper'

describe '管理画面：アカウント削除', type: :system do
  context 'ログインしているとき' do
    let!(:user) { FactoryBot.create(:user, name: '削除データ') }

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

      it '削除ボタンを押すと confirm アラートが出ること' do
        within "#delete_btn_#{user.id}" do
          click_on '削除'
          expect(page.driver.browser.switch_to.alert.text).to eq '本当に削除しますか?'
          page.driver.browser.switch_to.alert.accept
        end
      end

      it '削除ボタンを押すとレコードが削除されていること' do
        within "#delete_btn_#{user.id}" do
          click_on '削除'
          page.driver.browser.switch_to.alert.accept
        end
        aggregate_failures do
          expect(page).to have_current_path admin_users_path
          expect(page).to have_css '.green.lighten-4'
          expect(page).to have_content '削除いたしました'
          expect(page).not_to have_content user.name
        end
      end

      it 'レコードが1件減ること' do
        expect do
          within "#delete_btn_#{user.id}" do
            click_on '削除'
            page.driver.browser.switch_to.alert.accept
          end
          page.find('div', text: '削除いたしました', match: :first)
        end.to change(User.all, :count).by(-1)
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
