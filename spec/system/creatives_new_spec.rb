# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：クリエイティブ', type: :system do
  context 'ログインしているとき' do
    before do
      sign_in_as(login_user)
      visit new_company_creatives_path(login_user.company)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      it_behaves_like '権限が弱いこと'
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      context '正しく入力するとき' do
        before do
          fill_in 'クリエイティブ', with: '新規作成クリエイティブ名'
          click_on '登録する'
        end

        it '情報を作成できること' do
          creative = Creative.last
          aggregate_failures do
            expect(page).to have_current_path company_creatives_path(login_user.company)
            expect(page).to have_css '.green.lighten-4'
            expect(page).to have_content '登録いたしました'
            expect(page.all('tbody tr').last).to have_content creative.name
          end
        end
      end

      context 'すでに存在するnameを入力するとき' do
        let(:creatives) { FactoryBot.create(:creative, company: login_user.company) }

        before do
          fill_in 'クリエイティブ', with: creative.name
          click_on '登録する'
        end

        it '重複エラーで作成できないこと' do
          aggregate_failures do
            expect(page).to have_css '.red.lighten-4'
            expect(page).to have_content '登録に失敗しました'
            expect(page).to have_content 'クリエイティブ名はすでに存在します'
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
    let(:user) { FactoryBot.create(:user) }

    before do
      visit new_company_creatives_path(user.company)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end
end
