# frozen_string_literal: true

require 'rails_helper'

describe '管理画面：企業作成', type: :system do
  context 'ログインしているとき' do
    before do
      sign_in_as(login_user)
      visit new_admin_company_path
    end

    context '権限が not_administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_administrator) }

      it_behaves_like '権限が弱いこと'
    end

    context '権限が administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :administrator) }

      context '正しく入力するとき' do
        before do
          fill_in '企業名', with: '新規作成テスト企業'
          click_on '登録する'
        end

        it '情報を作成できること' do
          company = Company.last
          aggregate_failures do
            expect(page).to have_current_path admin_companies_path
            expect(page).to have_css '.green.lighten-4'
            expect(page).to have_content '登録いたしました'
            expect(page.all('tbody tr').last).to have_content company.name
            expect(page.all('tbody tr').last).to have_content company.decorate.show_created_at
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
      visit new_admin_company_path
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end
end
