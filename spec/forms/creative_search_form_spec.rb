# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreativeSearchForm, type: :model do
  describe 'attributes' do
    subject(:search_form) { described_class.new }

    describe '#name' do
      it '呼べること' do
        expect(search_form).to be_respond_to :name
      end
    end
  end

  describe '#search' do
    subject(:searched_creatives) { described_class.new(search_condition).search(current_user) }

    let!(:current_user) { FactoryBot.create(:user) }

    context '何も渡さないとき' do
      let(:search_condition) { nil }
      let!(:creative1) { FactoryBot.create(:creative, company: current_user.company) }
      let!(:creative2) { FactoryBot.create(:creative) }
      let!(:creative3) { FactoryBot.create(:creative, company: current_user.company) }

      it 'ログインアカウントと同じ企業に紐づくAdMediumが作成順に返ること' do
        aggregate_failures do
          expect(searched_creatives[0].id).to eq creative1.id
          expect(searched_creatives[1].id).to eq creative3.id
        end
      end

      it 'ログインアカウントと同じ企業に紐づくAdMediumが全件返ること' do
        expect(searched_cratives.count).to eq 2
      end
    end

    context 'nameで絞り込むとき' do
      let!(:creative) { FactoryBot.create(:creative, name: 'exist_name', company: current_user.company) }

      before do
        FactoryBot.create(:creative, name: 'exist_name')
      end

      context '存在するnameで検索するとき' do
        let(:search_condition) { { name: 'exist_name' } }

        it 'ログインアカウントと同じ企業に紐づくAdMediumで一致するnameのものだけ返ること' do
          aggregate_failures do
            expect(searched_creatives.count).to eq 1
            expect(searched_creatives[0].id).to eq creative.id
          end
        end
      end

      context '存在しないnameで検索するとき' do
        let(:search_condition) { { name: 'not_exist_name' } }

        it '空の配列が返ること' do
          expect(searched_creatives.count).to eq 0
        end
      end
    end
  end
end
