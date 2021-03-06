# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：ログインアカウントと違う企業に紐づくClientの削除', type: :system do
  let!(:client) { FactoryBot.create(:client, name: '削除データ') }

  context 'ログインしているとき' do
    before do
      sign_in_as(login_user)
      visit company_clients_path(login_user.company)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      it_behaves_like 'ボタンエクスペクテーション：not_be_able_to_destroy'
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      it '違う企業に紐づくClientの削除ボタンが存在しないこと' do
        expect(page).not_to have_content "delete_btn_#{client.id}"
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
end
