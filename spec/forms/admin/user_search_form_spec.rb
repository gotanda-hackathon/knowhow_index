# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UserSearchForm, type: :model do
  describe 'attributes' do
    subject(:search_form) { described_class.new }

    describe '#user_ids' do
      it '呼べること' do
        expect(search_form).to be_respond_to :user_ids
      end
    end

    describe '#company_ids' do
      it '呼べること' do
        expect(search_form).to be_respond_to :company_ids
      end
    end

    describe '#email' do
      it '呼べること' do
        expect(search_form).to be_respond_to :email
      end
    end

    describe '#grader' do
      it '呼べること' do
        expect(search_form).to be_respond_to :grader
      end
    end

    describe '#administrator' do
      it '呼べること' do
        expect(search_form).to be_respond_to :administrator
      end
    end
  end

  describe '#search' do
    subject(:searched_users) { described_class.new(search_condition).search }

    context '何も渡さないとき' do
      let(:search_condition) { nil }
      let!(:user1) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user) }
      let!(:user3) { FactoryBot.create(:user) }

      it '作成順に返ること' do
        aggregate_failures do
          expect(searched_users[0].id).to eq user1.id
          expect(searched_users[1].id).to eq user2.id
          expect(searched_users[2].id).to eq user3.id
        end
      end

      it 'Userが全件返ること' do
        expect(searched_users.count).to eq 3
      end
    end

    context 'user_idsで絞り込むとき' do
      let(:search_condition) { { user_ids: ids } }
      let!(:all_users) { FactoryBot.create_list(:user, 4) }
      let!(:ids) { all_users.select { |u| u.id.odd? }.map(&:id) }

      it '指定したidのUserだけ返ること' do
        aggregate_failures do
          expect(searched_users.count).to eq 2
          expect(searched_users[0].id).to eq ids[0]
          expect(searched_users[1].id).to eq ids[1]
        end
      end
    end

    context 'company_idsで絞り込むとき' do
      let!(:companys) { FactoryBot.create_list(:company, 2) }
      let!(:user1) { FactoryBot.create(:user, company_id: companys[0].id) }
      let!(:user2) { FactoryBot.create(:user, company_id: companys[1].id) }

      context '一つのcompanyで検索するとき' do
        let(:search_condition) { { company_ids: [companys[0].id] } }

        it '所属しているUserだけ返ること' do
          aggregate_failures do
            expect(searched_users.count).to eq 1
            expect(searched_users[0].id).to eq user1.id
          end
        end
      end

      context '複数のcompanyで検索するとき' do
        let(:search_condition) { { company_ids: [companys[0].id, companys[1].id] } }

        it '所属しているUserだけ返ること' do
          aggregate_failures do
            expect(searched_users.count).to eq 2
            expect(searched_users[0].id).to eq user1.id
            expect(searched_users[1].id).to eq user2.id
          end
        end
      end

      context '存在しないcompanyで検索するとき' do
        let(:search_condition) { { company_ids: [0] } }

        it '空の配列が返ること' do
          expect(searched_users.count).to eq 0
        end
      end
    end

    context 'emailで絞り込むとき' do
      let!(:user) { FactoryBot.create(:user, email: 'exist@test.com') }

      before do
        FactoryBot.create(:user)
      end

      context '存在するemailで検索するとき' do
        let(:search_condition) { { email: 'exist@test.com' } }

        it '一致するemailのものだけ返ること' do
          aggregate_failures do
            expect(searched_users.count).to eq 1
            expect(searched_users[0].id).to eq user.id
          end
        end
      end

      context '存在しないemailで検索するとき' do
        let(:search_condition) { { email: 'not_exist@test.com' } }

        it '空の配列が返ること' do
          expect(searched_users.count).to eq 0
        end
      end
    end

    context '採点者フラグで絞り込むとき' do
      let(:search_condition) { { grader: 'true' } }
      let!(:user) { FactoryBot.create(:user, :grader) }

      before do
        FactoryBot.create(:user, :not_grader)
      end

      it '指定したフラグのUserだけ返ること' do
        aggregate_failures do
          expect(searched_users.count).to eq 1
          expect(searched_users[0].id).to eq user.id
        end
      end
    end

    context '管理者フラグで絞り込むとき' do
      let(:search_condition) { { administrator: 'true' } }
      let!(:user) { FactoryBot.create(:user, :administrator) }

      before do
        FactoryBot.create(:user, :not_administrator)
      end

      it '指定したフラグのUserだけ返ること' do
        aggregate_failures do
          expect(searched_users.count).to eq 1
          expect(searched_users[0].id).to eq user.id
        end
      end
    end
  end
end
