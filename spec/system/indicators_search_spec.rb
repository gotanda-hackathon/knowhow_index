# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：改善指標検索', type: :system do
  context 'ログインしているとき' do
    let!(:indicator1) { FactoryBot.create(:indicator, company: login_user.company) }
    let!(:indicator2) { FactoryBot.create(:indicator) }

    before do
      sign_in_as(login_user)
      visit company_indicators_path(login_user.company)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        page.find('h5', text: '広告媒体一覧', match: :first)
      end

      context '存在するnameで検索するとき' do
        before do
          fill_in '改善指標名', with: indicator1.name
          click_on '検索'
        end

        it '検索条件に一致した広告媒体が表示されていること' do
          expect_not_grader_outline_of(indicator1)
        end

        it '検索条件に一致しなかった広告媒体が表示されていないこと' do
          expect_not_outline_of(indicator2)
        end

        it '検索条件に一致した広告媒体の数が表示されていること' do
          expect(page.find('#indicators_count')).to have_content '1 件'
        end
      end

      context '存在しない広告媒体で検索するとき' do
        before do
          fill_in '改善指標名', with: '存在しない広告媒体名'
          click_on '検索'
        end

        it '広告媒体が1件も表示されないこと' do
          expect(page.find('#indicators_count')).to have_content '0 件'
        end
      end
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        page.find('h5', text: '改善指標一覧', match: :first)
      end

      context '存在するnameで検索するとき' do
        before do
          fill_in '改善指標名', with: indicator1.name
          click_on '検索'
        end

        it '検索条件に一致した広告媒体が表示されていること' do
          expect_grader_outline_of(indicator1)
        end

        it '検索条件に一致しなかった広告媒体が表示されていないこと' do
          expect_not_outline_of(indicator2)
        end

        it '検索条件に一致したメールアドレスの数が表示されていること' do
          expect(page.find('#indicators_count')).to have_content '1 件'
        end
      end

      context '存在しない広告媒体で検索するとき' do
        before do
          fill_in '改善指標名', with: '存在しない改善指標名'
          click_on '検索'
        end

        it '改善指標が1件も表示されないこと' do
          expect(page.find('#indicators_count')).to have_content '0 件'
        end
      end
    end
  end

  context 'ログインしていないとき' do
    let(:user) { FactoryBot.create(:user) }

    before do
      visit company_indicatorspath(user.company)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end

  def expect_grader_outline_of(indicator)
    aggregate_failures do
      page.find('h5', text: '改善指標一覧', match: :first)
      within "#indicator_#{indicator.id}" do
        expect(page).to have_content indicator.name
        expect(page).to have_content '編集'
        expect(page).to have_content '削除'
      end
    end
  end

  def expect_not_grader_outline_of(indicator)
    aggregate_failures do
      page.find('h5', text: '改善指標一覧', match: :first)
      within "#indicator_#{ad_medium.id}" do
        expect(page).to have_content indicator.name
        expect(page).not_to have_content '編集'
        expect(page).not_to have_content '削除'
      end
    end
  end

  def expect_not_outline_of(indicator)
    expect(page).not_to have_css "#indicator_#{indicator.id}"
  end
end
