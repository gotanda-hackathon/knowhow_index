# frozen_string_literal: true

require 'rails_helper'

describe '管理画面：企業一覧', type: :system do
  context 'ログインしているとき' do
    let!(:companies) { FactoryBot.create_list(:company, 2) }

    before do
      sign_in_as(login_user)
      visit admin_companies_path
    end

    context '権限が not_administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_administrator) }

      it_behaves_like 'トップページにリダイレクト'
    end

    context '権限が administrator のとき' do
      let(:login_user) { FactoryBot.create(:user, :administrator) }

      it '企業の情報が表示されていること' do
        expect_outline_of(companies[0])
        expect_outline_of(companies[1])
      end

      it '編集ボタンが企業の数だけあること' do
        expect(page).to have_content('編集', count: Company.all.count)
      end

      it '削除ボタンが企業の数だけあること' do
        expect(page).to have_content('削除', count: Company.all.count)
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
    expect(page).to have_content company.name
    expect(page).to have_content company.decorate.show_created_at
  end
end
