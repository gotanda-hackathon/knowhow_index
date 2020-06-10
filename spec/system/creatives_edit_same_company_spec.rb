# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：ログインアカウントと同じ企業に紐づくCreativeの編集', type: :system do
  context 'ログインしているとき' do
    let!(:creative1) { FactoryBot.create(:creative, company: login_user.company) }

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        sign_in_as(login_user)
        visit edit_company_creatives_path(login_user.company, creative1)
      end

      it_behaves_like '権限が弱いこと'
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        sign_in_as(login_user)
        visit company_creatives_path(login_user.company)
      end

      context '正しく入力するとき' do
        before do
          within "#edit_btn_#{creative1.id}" do
            click_on '編集'
          end
          page.find('h5', text: 'クリエイティブ編集', match: :first)
          fill_in '媒体名', with: '編集テストクリエイティブ'
          click_on '更新する'
        end

        it '情報を編集・更新できること' do
          aggregate_failures do
            expect(page).to have_current_path edit_company_creatives_path(login_user.company, creative1)
            expect(page).to have_css '.green.lighten-4'
            expect(page).to have_content '更新いたしました'
            expect(page).to have_field 'クリエイティブ名', with: '編集テストクリエイティブ'
          end
        end
      end

      context 'すでに存在するnameを入力するとき' do
        let(:creative2) { FactoryBot.create(:creative, company: login_user.company) }

        before do
          within "#edit_btn_#{creative1.id}" do
            click_on '編集'
          end
          page.find('h5', text: 'クリエイティブ編集', match: :first)
          fill_in 'クリエイティブ名', with: creative2.name
          click_on '更新する'
        end

        it '重複エラーで作成できないこと' do
          aggregate_failures do
            expect(page).to have_css '.red.lighten-4'
            expect(page).to have_content '更新に失敗しました'
            expect(page).to have_content 'クリエイティブ名はすでに存在します'
          end
        end
      end

      context '値を空にするとき' do
        before do
          within "#edit_btn_#{creative1.id}" do
            click_on '編集'
          end
          page.find('h5', text: 'クリエイティブ編集', match: :first)
          fill_in 'クリエイティブ名', with: ''
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
    let(:user) { FactoryBot.create(:user) }

    before do
      visit edit_company_creatives_path(user.company, user)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end
end
