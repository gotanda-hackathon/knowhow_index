# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：アカウント一覧', type: :system do
  context 'ログインしているとき' do
    let!(:user1) { FactoryBot.create(:user, company: login_user.company) }
    let!(:user2) { FactoryBot.create(:user) }

    shared_examples '一覧表示' do
      it 'ログインアカウントと同じ企業に紐づくUser情報だけ表示されていること' do
        expect_outline_of(login_user)
        expect_outline_of(user1)
        expect_noy_outline_of(user2)
      end
    end

    before do
      sign_in_as(login_user)
      visit company_users_path(login_user.company)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      it_behaves_like '一覧表示'
      it_behaves_like 'ボタンエクスペクテーション：not_be_able_to_new'
      it_behaves_like 'ボタンエクスペクテーション：not_be_able_to_edit'
      it_behaves_like 'ボタンエクスペクテーション：not_be_able_to_destroy'
      it_behaves_like 'ボタンエクスペクテーション：not_be_able_to_csv_import'
      it_behaves_like 'ボタンエクスペクテーション：not_be_able_to_csv_export'
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      it_behaves_like '一覧表示'
      it_behaves_like 'ボタンエクスペクテーション：be_able_to_new'
      it_behaves_like 'ボタンエクスペクテーション：be_able_to_csv_import'
      it_behaves_like 'ボタンエクスペクテーション：be_able_to_csv_export'

      it '編集ボタンがログインアカウントと同じ企業に紐づくUserの数だけあること' do
        expect(page).to have_content('編集', count: User.same_company_with(login_user).count)
      end

      it '削除ボタンがログインアカウントと同じ企業に紐づくUserの数だけあること' do
        expect(page).to have_content('削除', count: User.same_company_with(login_user).count)
      end

      context 'ファイルをセットせずにCSV取込ボタンを押すとき' do
        before do
          click_on 'CSV取込'
        end

        it 'エラーになること' do
          aggregate_failures do
            expect(page).to have_current_path company_users_path(login_user.company)
            expect(page).to have_css '.red.lighten-4'
            expect(page).to have_content 'CSVファイルを取り込んでください'
          end
        end
      end
    end
  end

  context 'ログインしていないとき' do
    let(:user) { FactoryBot.create(:user) }

    before do
      visit company_users_path(user.company)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end

  def expect_outline_of(user)
    within "#user_#{user.id}" do
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content(user.grader? ? 'あり' : 'なし')
    end
  end

  def expect_noy_outline_of(user)
    expect(page).not_to have_css "#user_#{user.id}"
  end
end
