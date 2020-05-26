# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：ログインアカウントと同じ企業に紐づくClientの編集', type: :system do
  context 'ログインしているとき' do
    let!(:client1) { FactoryBot.create(:client, company: login_user.company) }

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        sign_in_as(login_user)
        visit edit_company_client_path(login_user.company, client1)
      end

      it_behaves_like '権限が弱いこと'
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        sign_in_as(login_user)
        visit company_clients_path(login_user.company)
      end

      context '正しく入力するとき' do
        before do
          within "#edit_btn_#{client1.id}" do
            click_on '編集'
          end
          page.find('h5', text: 'クライアント編集', match: :first)
          fill_in 'クライアント名', with: '編集テストクライアント'
          click_on '更新する'
        end

        it '情報を編集・更新できること' do
          aggregate_failures do
            expect(page).to have_current_path edit_company_client_path(login_user.company, client1)
            expect(page).to have_css '.green.lighten-4'
            expect(page).to have_content '更新いたしました'
            expect(page).to have_field 'クライアント名', with: '編集テストクライアント'
          end
        end
      end

      context 'すでに存在するnameを入力するとき' do
        let(:client2) { FactoryBot.create(:client, company: login_user.company) }

        before do
          within "#edit_btn_#{client1.id}" do
            click_on '編集'
          end
          page.find('h5', text: 'クライアント編集', match: :first)
          fill_in 'クライアント名', with: client2.name
          click_on '更新する'
        end

        it '重複エラーで作成できないこと' do
          aggregate_failures do
            expect(page).to have_css '.red.lighten-4'
            expect(page).to have_content '更新に失敗しました'
            expect(page).to have_content 'クライアント名はすでに存在します'
          end
        end
      end

      context '値を空にするとき' do
        before do
          within "#edit_btn_#{client1.id}" do
            click_on '編集'
          end
          page.find('h5', text: 'クライアント編集', match: :first)
          fill_in 'クライアント名', with: ''
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
