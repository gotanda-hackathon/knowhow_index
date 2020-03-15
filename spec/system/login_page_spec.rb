# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：ログインページ', type: :system do
  context '正しくログインするとき' do
    before do
      sign_in_as(login_user)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      it 'トップページが表示されること' do
        aggregate_failures do
          expect(page).to have_current_path root_path
          expect(page).to have_css '.green.lighten-4'
          expect(page).to have_content 'ログインしました'
        end
      end

      it 'サイドバーからログアウトできること' do
        click_on 'ログアウト'
        aggregate_failures do
          expect(page).to have_current_path login_path
          expect(page).to have_css '.green.lighten-4'
          expect(page).to have_content 'ログアウトしました'
        end
      end
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      it 'トップページが表示されること' do
        aggregate_failures do
          expect(page).to have_current_path root_path
          expect(page).to have_css '.green.lighten-4'
          expect(page).to have_content 'ログインしました'
        end
      end

      it 'サイドバーからログアウトできること' do
        click_on 'ログアウト'
        aggregate_failures do
          expect(page).to have_current_path login_path
          expect(page).to have_css '.green.lighten-4'
          expect(page).to have_content 'ログアウトしました'
        end
      end
    end
  end

  context '何も入力しないとき' do
    before do
      visit login_path
      click_on 'ログイン'
    end

    it 'ログインできずエラーが出ること' do
      aggregate_failures do
        expect(page).to have_css '.red.lighten-4'
        expect(page).to have_content 'ユーザー名またはパスワードが違います'
      end
    end
  end
end
