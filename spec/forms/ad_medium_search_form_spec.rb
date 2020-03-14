# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdMediumSearchForm, type: :model do
  describe 'attributes' do
    subject(:search_form) { described_class.new }

    describe '#name' do
      it '呼べること' do
        expect(search_form).to be_respond_to :name
      end
    end
  end

  describe '#search' do
    subject(:searched_ad_media) { described_class.new(search_condition).search(current_user) }

    let!(:current_user) { FactoryBot.create(:user) }

    context '何も渡さないとき' do
      let(:search_condition) { nil }
      let!(:ad_medium1) { FactoryBot.create(:ad_medium, company: current_user.company) }
      let!(:ad_medium2) { FactoryBot.create(:ad_medium) }
      let!(:ad_medium3) { FactoryBot.create(:ad_medium, company: current_user.company) }

      it 'ログインアカウントと同じ企業に紐づくAdMediumが作成順に返ること' do
        aggregate_failures do
          expect(searched_ad_media[0].id).to eq ad_medium1.id
          expect(searched_ad_media[1].id).to eq ad_medium3.id
        end
      end

      it 'ログインアカウントと同じ企業に紐づくAdMediumが全件返ること' do
        expect(searched_ad_media.count).to eq 2
      end
    end

    context 'nameで絞り込むとき' do
      let!(:ad_medium) { FactoryBot.create(:ad_medium, name: 'exist_name', company: current_user.company) }

      before do
        FactoryBot.create(:ad_medium, name: 'exist_name')
      end

      context '存在するnameで検索するとき' do
        let(:search_condition) { { name: 'exist_name' } }

        it 'ログインアカウントと同じ企業に紐づくアカウント内でヒットする媒体名のAdMediumだけ返ること' do
          aggregate_failures do
            expect(searched_ad_media.count).to eq 1
            expect(searched_ad_media[0].id).to eq ad_medium.id
          end
        end
      end

      context '存在しないnameで検索するとき' do
        let(:search_condition) { { name: 'not_exist_name' } }

        it '空の配列が返ること' do
          expect(searched_ad_media.count).to eq 0
        end
      end
    end
  end
end
