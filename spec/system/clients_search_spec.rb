# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：クライアント検索', type: :system do
  context 'ログインしているとき' do
    let!(:client1) { FactoryBot.create(:client, company: login_user.company) }
    let!(:client2) { FactoryBot.create(:client) }

    before do
      sign_in_as(login_user)
      visit company_clients_path(login_user.company)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        page.find('h5', text: 'クライアント一覧', match: :first)
      end

      context '存在するnameで検索するとき' do
        before do
          fill_in 'クライアント名', with: client1.name
          click_on '検索'
        end

        it '検索条件に一致したクライアントが表示されていること' do
          expect_not_grader_outline_of(client1)
        end

        it '検索条件に一致しなかったクライアントが表示されていないこと' do
          expect_not_outline_of(client2)
        end

        it '検索条件に一致したクライアントの数が表示されていること' do
          expect(page.find('#clients_count')).to have_content '1 件'
        end
      end

      context '存在しないクライアントで検索するとき' do
        before do
          fill_in 'クライアント名', with: '存在しないクライアント名'
          click_on '検索'
        end

        it 'クライアントが1件も表示されないこと' do
          expect(page.find('#clients_count')).to have_content '0 件'
        end
      end
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        page.find('h5', text: 'クライアント一覧', match: :first)
      end

      context '存在するnameで検索するとき' do
        before do
          fill_in 'クライアント名', with: client1.name
          click_on '検索'
        end

        it '検索条件に一致したクライアントが表示されていること' do
          expect_grader_outline_of(client1)
        end

        it '検索条件に一致しなかったクライアントが表示されていないこと' do
          expect_not_outline_of(client2)
        end

        it '検索条件に一致したメールアドレスの数が表示されていること' do
          expect(page.find('#clients_count')).to have_content '1 件'
        end
      end

      context '存在しないクライアントで検索するとき' do
        before do
          fill_in 'クライアント名', with: '存在しないクライアント名'
          click_on '検索'
        end

        it 'クライアントが1件も表示されないこと' do
          expect(page.find('#clients_count')).to have_content '0 件'
        end
      end
    end
  end

  context 'ログインしていないとき' do
    let(:user) { FactoryBot.create(:user) }

    before do
      visit company_clients_path(user.company)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end

  def expect_grader_outline_of(client)
    aggregate_failures do
      page.find('h5', text: 'クライアント一覧', match: :first)
      within "#client_#{client.id}" do
        expect(page).to have_content client.name
        expect(page).to have_content '編集'
        expect(page).to have_content '削除'
      end
    end
  end

  def expect_not_grader_outline_of(client)
    aggregate_failures do
      page.find('h5', text: 'クライアント一覧', match: :first)
      within "#client_#{client.id}" do
        expect(page).to have_content client.name
        expect(page).not_to have_content '編集'
        expect(page).not_to have_content '削除'
      end
    end
  end

  def expect_not_outline_of(client)
    expect(page).not_to have_css "#client_#{client.id}"
  end
end
