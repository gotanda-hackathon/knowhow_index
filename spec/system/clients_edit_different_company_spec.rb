# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：ログインアカウントと違う企業に紐づくClientの編集', type: :system do
  let!(:client) { FactoryBot.create(:client) }

  context 'ログインしているとき' do
    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        sign_in_as(login_user)
        visit edit_company_client_path(login_user.company, client)
      end

      it_behaves_like '別の企業情報にアクセスすること'
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        sign_in_as(login_user)
        visit edit_company_client_path(login_user.company, client)
      end

      it_behaves_like '別の企業情報にアクセスすること'
    end
  end

  context 'ログインしていないとき' do
    let(:user) { FactoryBot.create(:user) }

    before do
      visit edit_company_client_path(user.company, client)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end
end
