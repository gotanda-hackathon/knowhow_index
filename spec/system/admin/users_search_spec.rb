# frozen_string_literal: true

require 'rails_helper'

describe '管理画面：アカウント検索', type: :system do
  context 'ログインしているとき' do
    let!(:user) { FactoryBot.create(:user, :normal) }

    before do
      sign_in_as(login_user)
      visit admin_users_path
      page.find('h5', text: 'アカウント一覧', match: :first)
    end

    context '権限が not_administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_administrator) }

      it_behaves_like 'トップページにリダイレクト'
    end

    context '権限が administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :administrator) }

      context 'ユーザーの氏名を1つだけ指定するとき' do
        before do
          find('div.user_ids div.select-wrapper input', text: '').click
          find('div.user_ids div.select-wrapper li span label span', text: user.name).click
          click_on '検索'
        end

        it '検索条件にヒットしたアカウントの情報が表示されていること' do
          expect_outline_of(user)
        end

        it '検索条件にヒットしなかったアカウントの情報が表示されていないこと' do
          expect_not_outline_of(login_user)
        end

        it '検索条件にヒットしたアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '1 件'
        end
      end

      context 'ユーザーの氏名を複数指定するとき' do
        before do
          find('div.user_ids div.select-wrapper input', text: '').click
          find('div.user_ids div.select-wrapper li span label span', text: user.name).click
          find('div.user_ids div.select-wrapper li span label span', text: login_user.name).click
          click_on '検索'
        end

        it '検索条件にヒットしたアカウントの情報が表示されていること' do
          expect_outline_of(user)
          expect_outline_of(login_user)
        end

        it '検索条件にヒットしたアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '2 件'
        end
      end

      context '企業を1つだけ指定するとき' do
        before do
          find('div.company_ids div.select-wrapper input', text: '').click
          find('div.company_ids div.select-wrapper li span label span', text: user.company.name).click
          click_on '検索'
        end

        it '検索条件にヒットしたアカウントの情報が表示されていること' do
          expect_outline_of(user)
        end

        it '検索条件にヒットしなかったアカウントの情報が表示されていないこと' do
          expect_not_outline_of(login_user)
        end

        it '検索条件にヒットしたアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '1 件'
        end
      end

      context '企業を複数指定するとき' do
        before do
          find('div.company_ids div.select-wrapper input', text: '').click
          find('div.company_ids div.select-wrapper li span label span', text: user.company.name).click
          find('div.company_ids div.select-wrapper li span label span', text: login_user.company.name).click
          click_on '検索'
        end

        it '検索条件にヒットしたアカウントの情報が表示されていること' do
          expect_outline_of(user)
          expect_outline_of(login_user)
        end

        it '検索条件にヒットしたアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '2 件'
        end
      end

      context '採点者フラグ「あり」を指定するとき' do
        let!(:grader) { FactoryBot.create(:user, :grader) }

        before do
          find('div.grader_flag div.select-wrapper input', text: '').click
          find('div.grader_flag  div.select-wrapper li span', text: 'あり').click
          click_on '検索'
        end

        it '検索条件にヒットしたアカウントの情報が表示されていること' do
          expect_outline_of(grader)
        end

        it '検索条件にヒットしていないアカウントの情報が表示されていないこと' do
          expect_not_outline_of(login_user)
          expect_not_outline_of(user)
        end

        it '検索条件にヒットしたアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '1 件'
        end
      end

      context '存在するメールアドレスで検索するとき' do
        before do
          fill_in 'メールアドレス', with: user.email
          click_on '検索'
        end

        it '検索条件にヒットしたアカウントの情報が表示されていること' do
          expect_outline_of(user)
        end

        it '検索条件にヒットしなかったアカウントの情報が表示されていないこと' do
          expect_not_outline_of(login_user)
        end

        it '検索条件にヒットしたメールアドレスの数が表示されていること' do
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

      context '採点者フラグ「なし」を指定するとき' do
        let!(:grader) { FactoryBot.create(:user, :grader) }

        before do
          find('div.grader_flag div.select-wrapper input', text: '').click
          find('div.grader_flag  div.select-wrapper li span', text: 'なし').click
          click_on '検索'
        end

        it '検索条件にヒットしたアカウントの情報が表示されていること' do
          expect_outline_of(login_user)
          expect_outline_of(user)
        end

        it '検索条件にヒットしていないアカウントの情報が表示されていないこと' do
          expect_not_outline_of(grader)
        end

        it '検索条件にヒットしたアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '2 件'
        end
      end

      context '管理者フラグ「あり」を指定するとき' do
        let!(:administrator) { FactoryBot.create(:user, :administrator) }

        before do
          find('div.administrator_flag div.select-wrapper input', text: '').click
          find('div.administrator_flag  div.select-wrapper li span', text: 'あり').click
          click_on '検索'
        end

        it '検索条件にヒットしたアカウントの情報が表示されていること' do
          expect_outline_of(administrator)
          expect_outline_of(login_user)
        end

        it '検索条件にヒットしていないアカウントの情報が表示されていないこと' do
          expect_not_outline_of(user)
        end

        it '検索条件にヒットしたアカウントの数が表示されていること' do
          expect(page.find('#users_count')).to have_content '2 件'
        end
      end

      context '管理者フラグ「なし」を指定するとき' do
        let!(:administrator) { FactoryBot.create(:user, :administrator) }

        before do
          find('div.administrator_flag div.select-wrapper input', text: '').click
          find('div.administrator_flag  div.select-wrapper li span', text: 'なし').click
          click_on '検索'
        end

        it '検索条件にヒットしたアカウントの情報が表示されていること' do
          expect_outline_of(user)
        end

        it '検索条件にヒットしていないアカウントの情報が表示されていないこと' do
          expect_not_outline_of(administrator)
          expect_not_outline_of(login_user)
        end

        it '検索条件にヒットしたアカウントの数が表示されていること' do
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

  def expect_outline_of(user)
    aggregate_failures do
      within "#user_#{user.id}" do
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content user.company.name
        expect(page).to have_content(user.grader? ? 'あり' : 'なし')
        expect(page).to have_content(user.administrator? ? 'あり' : 'なし')
      end
    end
  end

  def expect_not_outline_of(user)
    expect(page).not_to have_css "#user_#{user.id}"
  end
end
