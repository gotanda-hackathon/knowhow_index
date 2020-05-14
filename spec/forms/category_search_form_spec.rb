# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategorySearchForm, type: :model do
  describe 'attributes' do
    subject(:search_form) { described_class.new }

    describe '#name' do
      it '呼べること' do
        expect(search_form).to be_respond_to :name
      end
    end
  end

  describe '#search' do
    subject(:searched_categories) { described_class.new(search_condition).search(current_user) }

    let!(:current_user) { FactoryBot.create(:user) }

    context '何も渡さないとき' do
      let(:search_condition) { nil }
      let!(:category1) { FactoryBot.create(:category, company: current_user.company) }
      let!(:category2) { FactoryBot.create(:category) }
      let!(:category3) { FactoryBot.create(:category, company: current_user.company) }

      it 'ログインアカウントと同じ企業に紐づくCategoryが作成順に返ること' do
        aggregate_failures do
          expect(searched_categories[0].id).to eq category1.id
          expect(searched_categories[1].id).to eq category3.id
        end
      end

      it 'ログインアカウントと同じ企業に紐づくCategoryが全件返ること' do
        expect(searched_categories.count).to eq 2
      end
    end

    context 'nameで絞り込むとき' do
      let!(:category) { FactoryBot.create(:category, name: 'exist_name', company: current_user.company) }

      before do
        FactoryBot.create(:category, name: 'exist_name')
      end

      context '存在するnameで検索するとき' do
        let(:search_condition) { { name: 'exist_name' } }

        it 'ログインアカウントと同じ企業に紐づくCategoryで一致するnameのものだけ返ること' do
          aggregate_failures do
            expect(searched_categories.count).to eq 1
            expect(searched_categories[0].id).to eq category.id
          end
        end
      end

      context '存在しないnameで検索するとき' do
        let(:search_condition) { { name: 'not_exist_name' } }

        it '空の配列が返ること' do
          expect(searched_categories.count).to eq 0
        end
      end
    end
  end
end
