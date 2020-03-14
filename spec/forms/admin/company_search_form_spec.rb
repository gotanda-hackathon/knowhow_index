# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CompanySearchForm, type: :model do
  describe 'attributes' do
    subject(:search_form) { described_class.new }

    describe '#name' do
      it '呼べること' do
        expect(search_form).to be_respond_to :name
      end
    end
  end

  describe '#search' do
    subject(:searched_companies) { described_class.new(search_condition).search }

    context '何も渡さないとき' do
      let(:search_condition) { nil }
      let!(:company1) { FactoryBot.create(:company) }
      let!(:company2) { FactoryBot.create(:company) }
      let!(:company3) { FactoryBot.create(:company) }

      it '作成順に返ること' do
        aggregate_failures do
          expect(searched_companies[0].id).to eq company1.id
          expect(searched_companies[1].id).to eq company2.id
          expect(searched_companies[2].id).to eq company3.id
        end
      end

      it 'companyが全件返ること' do
        expect(searched_companies.count).to eq 3
      end
    end

    context 'nameで絞り込むとき' do
      let!(:company) { FactoryBot.create(:company, name: 'exist_name') }

      before do
        FactoryBot.create(:company)
      end

      context '存在するnameで検索するとき' do
        let(:search_condition) { { name: 'exist_name' } }

        it '一致するnameのものだけ返ること' do
          aggregate_failures do
            expect(searched_companies.count).to eq 1
            expect(searched_companies[0].id).to eq company.id
          end
        end
      end

      context '存在しないnameで検索するとき' do
        let(:search_condition) { { name: 'not_exist_name' } }

        it '空の配列が返ること' do
          expect(searched_companies.count).to eq 0
        end
      end
    end
  end
end
