# frozen_string_literal: true

require 'rails_helper'

describe 'フロント画面：カテゴリ検索', type: :system do
  context 'ログインしているとき' do
    let!(:category1) { FactoryBot.create(:category, company: login_user.company) }
    let!(:category2) { FactoryBot.create(:category) }

    before do
      sign_in_as(login_user)
      visit company_categories_path(login_user.company)
    end

    context '権限が not_grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :not_grader) }

      before do
        page.find('h5', text: 'カテゴリ一覧', match: :first)
      end

      context '存在するnameで検索するとき' do
        before do
          fill_in 'カテゴリ名', with: category1.name
          click_on '検索'
        end

        it '検索条件に一致したカテゴリが表示されていること' do
          expect_not_grader_outline_of(category1)
        end

        it '検索条件に一致しなかったカテゴリが表示されていないこと' do
          expect_not_outline_of(category2)
        end

        it '検索条件に一致したカテゴリの数が表示されていること' do
          expect(page.find('#categories_count')).to have_content '1 件'
        end
      end

      context '存在しないカテゴリで検索するとき' do
        before do
          fill_in 'カテゴリ名', with: '存在しないカテゴリ名'
          click_on '検索'
        end

        it 'カテゴリが1件も表示されないこと' do
          expect(page.find('#categories_count')).to have_content '0 件'
        end
      end
    end

    context '権限が grader のとき' do
      let(:login_user) { FactoryBot.create(:user, :grader) }

      before do
        page.find('h5', text: 'カテゴリ一覧', match: :first)
      end

      context '存在するnameで検索するとき' do
        before do
          fill_in 'カテゴリ名', with: category1.name
          click_on '検索'
        end

        it '検索条件に一致したカテゴリが表示されていること' do
          expect_grader_outline_of(category1)
        end

        it '検索条件に一致しなかったカテゴリが表示されていないこと' do
          expect_not_outline_of(category2)
        end

        it '検索条件に一致したメールアドレスの数が表示されていること' do
          expect(page.find('#categories_count')).to have_content '1 件'
        end
      end

      context '存在しないカテゴリで検索するとき' do
        before do
          fill_in 'カテゴリ名', with: '存在しないカテゴリ名'
          click_on '検索'
        end

        it 'カテゴリが1件も表示されないこと' do
          expect(page.find('#categories_count')).to have_content '0 件'
        end
      end
    end
  end

  context 'ログインしていないとき' do
    let(:user) { FactoryBot.create(:user) }

    before do
      visit company_categories_path(user.company)
    end

    it_behaves_like 'ログイン画面にリダイレクト'
  end

  def expect_grader_outline_of(category)
    aggregate_failures do
      page.find('h5', text: 'カテゴリ一覧', match: :first)
      within "#category_#{category.id}" do
        expect(page).to have_content category.name
        expect(page).to have_content '編集'
        expect(page).to have_content '削除'
      end
    end
  end

  def expect_not_grader_outline_of(category)
    aggregate_failures do
      page.find('h5', text: 'カテゴリ一覧', match: :first)
      within "#category_#{category.id}" do
        expect(page).to have_content category.name
        expect(page).not_to have_content '編集'
        expect(page).not_to have_content '削除'
      end
    end
  end

  def expect_not_outline_of(category)
    expect(page).not_to have_css "#category_#{category.id}"
  end
end
