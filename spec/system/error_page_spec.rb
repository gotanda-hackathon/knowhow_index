# frozen_string_literal: true

require 'rails_helper'

describe 'エラーページ', type: :system, js: true do
  let(:login_user) { FactoryBot.create(:user) }

  context '500エラーページに遷移するとき' do
    let(:my_instance) { instance_double(UserSearchForm) }

    before do
      sign_in_as(login_user)
      allow(UserSearchForm).to receive(:new).and_return(my_instance)
      allow(my_instance).to receive(:search).and_throw(Exception)
      visit company_users_path(login_user.company)
    end

    it '500エラーが出ること' do
      expect(page).to have_content 'エラーが発生しました。管理者に問い合わせください。'
    end
  end

  context '404エラーページに遷移するとき' do
    before do
      sign_in_as(login_user)
      visit '/404error_page'
    end

    it '404エラーが出ること' do
      expect(page).to have_content 'ご指定になったページは存在しません'
    end
  end
end
