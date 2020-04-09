# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：改善指標一覧', type: :system do
  context 'ログインしているとき' do
    let!(:indicator1) { FactoryBot.create(:indicator, company: login_user.company) }
    let!(:indicator2) { FactoryBot.create(:indicator) }

    shared_examples '一覧表示' do
      it 'ログインアカウントと同じ企業に紐づくIndicatorだけ表示されていること' do
        expect_outline_of(indicator1)
        expect_noy_outline_of(indicator2)
      end
    end

    before do
      sign_in_as(login_user)
      visit company_indicators_path(login_user.company)
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

      it '編集ボタンがログインアカウントと同じ企業に紐づくIndicatorの数だけあること' do
        expect(page).to have_content('編集', count: Indicator.same_company_with(login_user).count)
      end

      it '削除ボタンがログインアカウントと同じ企業に紐づくAdMediumの数だけあること' do
        expect(page).to have_content('削除', count: Indicator.same_company_with(login_user).count)
      end

      context 'ファイルをセットせずにCSV取込ボタンを押すとき' do
        before do
          click_on 'CSV取込'
        end

        it 'エラーになること' do
          aggregate_failures do
            expect(page).to have_current_path company_indicators_path(login_user.company)
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
      visit company_indicators_path(user.company)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end

  def expect_outline_of(indicator)
    within "#indicators_#{indicator.id}" do
      expect(page).to have_content ad_medium.name
    end
  end

  def expect_noy_outline_of(indicator)
    expect(page).not_to have_css "#indicators_#{indicator.id}"
  end
end
