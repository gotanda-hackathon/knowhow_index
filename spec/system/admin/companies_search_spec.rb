# frozen_string_literal: true

require 'rails_helper'

describe '管理画面：企業検索', type: :system do
  context 'ログインしているとき' do
    let!(:company) { FactoryBot.create(:company) }

    before do
      sign_in_as(login_user)
      visit admin_companies_path
    end

    context '権限が not_administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_administrator) }

      it_behaves_like '権限が弱いこと'
    end

    context '権限が administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :administrator) }

      before do
        page.find('h5', text: '企業一覧', match: :first)
      end

      context '存在するnameで検索するとき' do
        before do
          fill_in '企業名', with: company.name
          click_on '検索'
        end

        it '検索条件に一致した企業が表示されていること' do
          expect_outline_of(company)
        end

        it '検索条件に一致しなかった企業が表示されていないこと' do
          expect_not_outline_of(login_user.company)
        end

        it '検索条件に一致した企業名の数が表示されていること' do
          expect(page.find('#companies_count')).to have_content '1 件'
        end
      end

      context '存在しない企業名で検索するとき' do
        before do
          fill_in '企業名', with: '存在しない企業名'
          click_on '検索'
        end

        it '企業が1件も表示されないこと' do
          expect(page.find('#companies_count')).to have_content '0 件'
        end
      end
    end
  end

  context 'ログインしていないとき' do
    before do
      visit admin_companies_path
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end

  def expect_outline_of(company)
    aggregate_failures do
      page.find('h5', text: '企業一覧', match: :first)
      within "#company_#{company.id}" do
        expect(page).to have_content company.name
        expect(page).to have_content company.decorate.show_created_at
      end
    end
  end

  def expect_not_outline_of(company)
    expect(page).not_to have_css "#company_#{company.id}"
  end
end
