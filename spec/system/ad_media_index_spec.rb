# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：広告媒体一覧', type: :system do
  context 'ログインしているとき' do
    let!(:ad_medium1) { FactoryBot.create(:ad_medium, company: login_user.company) }
    let!(:ad_medium2) { FactoryBot.create(:ad_medium) }

    shared_examples '一覧表示' do
      it 'ログインアカウントと同じ企業に紐づくAdMediumだけ表示されていること' do
        expect_outline_of(ad_medium1)
        expect_noy_outline_of(ad_medium2)
      end
    end

    before do
      sign_in_as(login_user)
      visit company_ad_media_path(login_user.company)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      it_behaves_like '一覧表示'
      it_behaves_like 'ボタンエクスペクテーション：not_be_able_to_new'
      it_behaves_like 'ボタンエクスペクテーション：not_be_able_to_edit'
      it_behaves_like 'ボタンエクスペクテーション：not_be_able_to_destroy'
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      it_behaves_like '一覧表示'
      it_behaves_like 'ボタンエクスペクテーション：be_able_to_new'

      it '編集ボタンがログインアカウントと同じ企業に紐づくAdMediumの数だけあること' do
        expect(page).to have_content('編集', count: AdMedium.same_as_current_user_company(login_user).count)
      end

      it '削除ボタンがログインアカウントと同じ企業に紐づくAdMediumの数だけあること' do
        expect(page).to have_content('削除', count: AdMedium.same_as_current_user_company(login_user).count)
      end
    end
  end

  context 'ログインしていないとき' do
    let(:user) { FactoryBot.create(:user) }

    before do
      visit company_ad_media_path(user.company)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end

  def expect_outline_of(ad_medium)
    within "#ad_medium_#{ad_medium.id}" do
      expect(page).to have_content ad_medium.name
    end
  end

  def expect_noy_outline_of(ad_medium)
    expect(page).not_to have_css "#ad_medium_#{ad_medium.id}"
  end
end
