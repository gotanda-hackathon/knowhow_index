# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：アカウント検索', type: :system do
  context 'ログインしているとき' do
    let!(:user1) { FactoryBot.create(:user, :normal, company: login_user.company) }
    let!(:user2) { FactoryBot.create(:user, :normal) }

    before do
      sign_in_as(login_user)
      visit company_users_path(login_user.company)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        page.find('h5', text: 'アカウント一覧', match: :first)
      end

      context 'ユーザーの氏名を1つだけ指定するとき' do
        before do
          find('div.user_ids div.select-wrapper input', text: '').click
          find('div.user_ids div.select-wrapper li span label span', text: user1.name).click
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_not_grader_outline_of(user1)
        end

        it '検索条件に一致しなかったアカウントが表示されていないこと' do
          expect_not_outline_of(login_user)
          expect_not_outline_of(user2)
        end

        it '検索条件に一致したアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '1 件'
        end
      end

      context 'ユーザーの氏名を複数指定するとき' do
        before do
          find('div.user_ids div.select-wrapper input', text: '').click
          find('div.user_ids div.select-wrapper li span label span', text: user1.name).click
          find('div.user_ids div.select-wrapper li span label span', text: login_user.name).click
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_not_grader_outline_of(user1)
          expect_not_grader_outline_of(login_user)
        end

        it '検索条件に一致しなかったアカウントが表示されていないこと' do
          expect_not_outline_of(user2)
        end

        it '検索条件に一致したアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '2 件'
        end
      end

      context '存在するemailで検索するとき' do
        before do
          fill_in 'メールアドレス', with: user1.email
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_not_grader_outline_of(user1)
        end

        it '検索条件に一致しなかったアカウントが表示されていないこと' do
          expect_not_outline_of(login_user)
          expect_not_outline_of(user2)
        end

        it '検索条件に一致したメールアドレスの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '1 件'
        end
      end

      context '存在しないメールアドレスで検索するとき' do
        before do
          fill_in 'メールアドレス', with: '存在しないメールアドレス'
          click_on '検索'
        end

        it 'アカウントが1件も表示されないこと' do
          expect(page.find('#users_count')).to have_content '0 件'
        end
      end

      context '採点者フラグ「あり」を指定するとき' do
        let!(:grader1) { FactoryBot.create(:user, :grader, company: login_user.company) }
        let!(:grader2) { FactoryBot.create(:user, :grader) }

        before do
          find('div.grader_flag div.select-wrapper input', text: '').click
          find('div.grader_flag  div.select-wrapper li span', text: 'あり').click
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_not_grader_outline_of(grader1)
        end

        it '検索条件に一致していないアカウントが表示されていないこと' do
          expect_not_outline_of(user1)
          expect_not_outline_of(user2)
          expect_not_outline_of(grader2)
          expect_not_outline_of(login_user)
        end

        it '検索条件に一致したアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '1 件'
        end
      end

      context '採点者フラグ「なし」を指定するとき' do
        let!(:grader1) { FactoryBot.create(:user, :grader, company: login_user.company) }
        let!(:grader2) { FactoryBot.create(:user, :grader) }

        before do
          find('div.grader_flag div.select-wrapper input', text: '').click
          find('div.grader_flag  div.select-wrapper li span', text: 'なし').click
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_not_grader_outline_of(user1)
          expect_not_grader_outline_of(login_user)
        end

        it '検索条件に一致していないアカウントが表示されていないこと' do
          expect_not_outline_of(grader1)
          expect_not_outline_of(grader2)
          expect_not_outline_of(user2)
        end

        it '検索条件に一致したアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '2 件'
        end
      end
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        page.find('h5', text: 'アカウント一覧', match: :first)
      end

      context 'ユーザーの氏名を1つだけ指定するとき' do
        before do
          find('div.user_ids div.select-wrapper input', text: '').click
          find('div.user_ids div.select-wrapper li span label span', text: user1.name).click
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_grader_outline_of(user1)
        end

        it '検索条件に一致しなかったアカウントが表示されていないこと' do
          expect_not_outline_of(login_user)
          expect_not_outline_of(user2)
        end

        it '検索条件に一致したアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '1 件'
        end
      end

      context 'ユーザーの氏名を複数指定するとき' do
        before do
          find('div.user_ids div.select-wrapper input', text: '').click
          find('div.user_ids div.select-wrapper li span label span', text: user1.name).click
          find('div.user_ids div.select-wrapper li span label span', text: login_user.name).click
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_grader_outline_of(user1)
          expect_grader_outline_of(login_user)
        end

        it '検索条件に一致しなかったアカウントが表示されていないこと' do
          expect_not_outline_of(user2)
        end

        it '検索条件に一致したアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '2 件'
        end
      end

      context '存在するemailで検索するとき' do
        before do
          fill_in 'メールアドレス', with: user1.email
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_grader_outline_of(user1)
        end

        it '検索条件に一致しなかったアカウントが表示されていないこと' do
          expect_not_outline_of(login_user)
          expect_not_outline_of(user2)
        end

        it '検索条件に一致したメールアドレスの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '1 件'
        end
      end

      context '存在しないメールアドレスで検索するとき' do
        before do
          fill_in 'メールアドレス', with: '存在しないメールアドレス'
          click_on '検索'
        end

        it 'アカウントが1件も表示されないこと' do
          expect(page.find('#users_count')).to have_content '0 件'
        end
      end

      context '採点者フラグ「あり」を指定するとき' do
        let!(:grader1) { FactoryBot.create(:user, :grader, company: login_user.company) }
        let!(:grader2) { FactoryBot.create(:user, :grader) }

        before do
          find('div.grader_flag div.select-wrapper input', text: '').click
          find('div.grader_flag  div.select-wrapper li span', text: 'あり').click
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_grader_outline_of(grader1)
          expect_grader_outline_of(login_user)
        end

        it '検索条件に一致していないアカウントが表示されていないこと' do
          expect_not_outline_of(user1)
          expect_not_outline_of(user2)
          expect_not_outline_of(grader2)
        end

        it '検索条件に一致したアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '2 件'
        end
      end

      context '採点者フラグ「なし」を指定するとき' do
        let!(:grader1) { FactoryBot.create(:user, :grader, company: login_user.company) }
        let!(:grader2) { FactoryBot.create(:user, :grader) }

        before do
          find('div.grader_flag div.select-wrapper input', text: '').click
          find('div.grader_flag  div.select-wrapper li span', text: 'なし').click
          click_on '検索'
        end

        it '検索条件に一致したアカウントが表示されていること' do
          expect_grader_outline_of(user1)
        end

        it '検索条件に一致していないアカウントが表示されていないこと' do
          expect_not_outline_of(grader1)
          expect_not_outline_of(grader2)
          expect_not_outline_of(login_user)
          expect_not_outline_of(user2)
        end

        it '検索条件に一致したアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '1 件'
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

  def expect_grader_outline_of(user)
    aggregate_failures do
      page.find('h5', text: 'アカウント一覧', match: :first)
      within "#user_#{user.id}" do
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content(user.grader? ? 'あり' : 'なし')
        expect(page).to have_content '編集'
        expect(page).to have_content '削除'
      end
    end
  end

  def expect_not_grader_outline_of(user)
    aggregate_failures do
      page.find('h5', text: 'アカウント一覧', match: :first)
      within "#user_#{user.id}" do
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content(user.grader? ? 'あり' : 'なし')
        expect(page).not_to have_content '編集'
        expect(page).not_to have_content '削除'
      end
    end
  end

  def expect_not_outline_of(user)
    expect(page).not_to have_css "#user_#{user.id}"
  end
end
