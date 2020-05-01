# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientSearchForm, type: :model do
  describe 'attributes' do
    subject(:search_form) { described_class.new }

    describe '#name' do
      it '呼べること' do
        expect(search_form).to be_respond_to :name
      end
    end
  end

  describe '#search' do
    subject(:searched_clients) { described_class.new(search_condition).search(current_user) }

    let!(:current_user) { FactoryBot.create(:user) }

    context '何も渡さないとき' do
      let(:search_condition) { nil }
      let!(:client1) { FactoryBot.create(:client, company: current_user.company) }
      let!(:client2) { FactoryBot.create(:client) }
      let!(:client3) { FactoryBot.create(:client, company: current_user.company) }

      it 'ログインアカウントと同じ企業に紐づくClientが作成順に返ること' do
        aggregate_failures do
          expect(searched_clients[0].id).to eq client1.id
          expect(searched_clients[1].id).to eq client3.id
        end
      end

      it 'ログインアカウントと同じ企業に紐づくClientが全件返ること' do
        expect(searched_clients.count).to eq 2
      end
    end

    context 'nameで絞り込むとき' do
      let!(:client) { FactoryBot.create(:client, name: 'exist_name', company: current_user.company) }

      before do
        FactoryBot.create(:client, name: 'exist_name')
      end

      context '存在するnameで検索するとき' do
        let(:search_condition) { { name: 'exist_name' } }

        it 'ログインアカウントと同じ企業に紐づくClientで一致するnameのものだけ返ること' do
          aggregate_failures do
            expect(searched_clients.count).to eq 1
            expect(searched_clients[0].id).to eq client.id
          end
        end
      end

      context '存在しないnameで検索するとき' do
        let(:search_condition) { { name: 'not_exist_name' } }

        it '空の配列が返ること' do
          expect(searched_clients.count).to eq 0
        end
      end
    end
  end
end
