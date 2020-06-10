# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：クリエイティブ検索', type: :system do
  context 'ログインしているとき' do
    let!(:creative1) { FactoryBot.create(:creative, company: login_user.company) }
    let!(:creative2) { FactoryBot.create(:creative) }

    before do
      sign_in_as(login_user)
      visit company_creatives_path(login_user.company)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        page.find('h5', text: 'クリエイティブ一覧', match: :first)
      end

      context '存在するnameで検索するとき' do
        before do
          fill_in 'クリエイティブ名', with: creative1.name
          click_on '検索'
        end

        it '検索条件に一致した広告媒体が表示されていること' do
          expect_not_grader_outline_of(creative1)
        end

        it '検索条件に一致しなかった広告媒体が表示されていないこと' do
          expect_not_outline_of(creative2)
        end

        it '検索条件に一致した広告媒体の数が表示されていること' do
          expect(page.find('#creatives_count')).to have_content '1 件'
        end
      end

      context '存在しない広告媒体で検索するとき' do
        before do
          fill_in 'クリエイティブ名', with: '存在しないクリエイティブ名'
          click_on '検索'
        end

        it '広告媒体が1件も表示されないこと' do
          expect(page.find('#creatives_count')).to have_content '0 件'
        end
      end
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        page.find('h5', text: 'クリエイティブ一覧', match: :first)
      end

      context '存在するnameで検索するとき' do
        before do
          fill_in 'クリエイティブ名', with: creative1.name
          click_on '検索'
        end

        it '検索条件に一致した広告媒体が表示されていること' do
          expect_grader_outline_of(creative1)
        end

        it '検索条件に一致しなかった広告媒体が表示されていないこと' do
          expect_not_outline_of(creative2)
        end

        it '検索条件に一致したメールアドレスの数が表示されていること' do
          expect(page.find('#creative2_count')).to have_content '1 件'
        end
      end

      context '存在しない広告媒体で検索するとき' do
        before do
          fill_in 'クリエイティブ名', with: '存在しないクリエイティブ名'
          click_on '検索'
        end

        it 'クリエイティブが1件も表示されないこと' do
          expect(page.find('#creatives_count')).to have_content '0 件'
        end
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

  def expect_grader_outline_of(ad_medium)
    aggregate_failures do
      page.find('h5', text: '広告媒体一覧', match: :first)
      within "#ad_medium_#{ad_medium.id}" do
        expect(page).to have_content ad_medium.name
        expect(page).to have_content '編集'
        expect(page).to have_content '削除'
      end
    end
  end

  def expect_not_grader_outline_of(ad_medium)
    aggregate_failures do
      page.find('h5', text: '広告媒体一覧', match: :first)
      within "#ad_medium_#{ad_medium.id}" do
        expect(page).to have_content ad_medium.name
        expect(page).not_to have_content '編集'
        expect(page).not_to have_content '削除'
      end
    end
  end

  def expect_not_outline_of(ad_medium)
    expect(page).not_to have_css "#ad_medium_#{ad_medium.id}"
  end
end
