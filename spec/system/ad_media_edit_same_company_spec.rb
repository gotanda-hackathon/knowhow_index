# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：ログインアカウントと同じ企業に紐づくAdMediumの編集', type: :system do
  context 'ログインしているとき' do
    let!(:ad_medium1) { FactoryBot.create(:ad_medium, company: login_user.company) }

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        sign_in_as(login_user)
        visit edit_company_ad_medium_path(login_user.company, ad_medium1)
      end

      it_behaves_like '権限が弱いこと'
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        sign_in_as(login_user)
        visit company_ad_media_path(login_user.company)
      end

      context '正しく入力するとき' do
        before do
          within "#edit_btn_#{ad_medium1.id}" do
            click_on '編集'
          end
          page.find('h5', text: '広告媒体編集', match: :first)
          fill_in '媒体名', with: '編集テスト広告媒体'
          click_on '更新する'
        end

        it '情報を編集・更新できること' do
          aggregate_failures do
            expect(page).to have_current_path edit_company_ad_medium_path(login_user.company, ad_medium1)
            expect(page).to have_css '.green.lighten-4'
            expect(page).to have_content '更新いたしました'
            expect(page).to have_field '媒体名', with: '編集テスト広告媒体'
          end
        end
      end

      context 'すでに存在するnameを入力するとき' do
        let(:ad_medium2) { FactoryBot.create(:ad_medium, company: login_user.company) }

        before do
          within "#edit_btn_#{ad_medium1.id}" do
            click_on '編集'
          end
          page.find('h5', text: '広告媒体編集', match: :first)
          fill_in '広告媒体名', with: ad_medium2.name
          click_on '更新する'
        end

        it '重複エラーで作成できないこと' do
          aggregate_failures do
            expect(page).to have_css '.red.lighten-4'
            expect(page).to have_content '更新に失敗しました'
            expect(page).to have_content '広告媒体名はすでに存在しています'
          end
        end
      end

      context '値を空にするとき' do
        before do
          within "#edit_btn_#{ad_medium1.id}" do
            click_on '編集'
          end
          page.find('h5', text: '広告媒体編集', match: :first)
          fill_in '媒体名', with: ''
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
      visit edit_company_user_path(user.company, user)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end
end
