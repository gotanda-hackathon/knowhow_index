# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：ログインアカウントと違う企業に紐づくUserの編集', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  context 'ログインしているとき' do
    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        sign_in_as(login_user)
        visit edit_company_user_path(login_user.company, user)
      end

      it_behaves_like 'トップページにリダイレクト'
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        sign_in_as(login_user)
        visit edit_company_user_path(login_user.company, user)
      end

      it_behaves_like 'トップページにリダイレクト'
    end
  end

  context 'ログインしていないとき' do
    before do
      visit edit_company_user_path(user.company, user)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end
end
