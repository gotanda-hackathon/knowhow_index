# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSearchForm, type: :model do
  describe 'attributes' do
    subject(:search_form) { described_class.new }

    describe '#user_ids' do
      it '呼べること' do
        expect(search_form).to be_respond_to :user_ids
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
  end

  describe '#search' do
    subject(:searched_users) { described_class.new(search_condition).search(current_user) }

    let!(:current_user) { FactoryBot.create(:user, :grader) }

    context '何も渡さないとき' do
      let(:search_condition) { nil }
      let!(:user1) { FactoryBot.create(:user, company: current_user.company) }
      let!(:user2) { FactoryBot.create(:user) }
      let!(:user3) { FactoryBot.create(:user, company: current_user.company) }

      it 'ログインアカウントと同じ企業に紐づくUserが作成順に返ること' do
        aggregate_failures do
          expect(searched_users[0].id).to eq current_user.id
          expect(searched_users[1].id).to eq user1.id
          expect(searched_users[2].id).to eq user3.id
        end
      end

      it 'ログインアカウントと同じ企業に紐づくUserが全件返ること' do
        expect(searched_users.count).to eq 3
      end
    end

    context 'user_idsで絞り込むとき' do
      let(:search_condition) { { user_ids: ids1 + ids2 } }
      let!(:same_company_users) { FactoryBot.create_list(:user, 4, company: current_user.company) }
      let!(:different_company_users) { FactoryBot.create_list(:user, 4) }
      let!(:ids1) { same_company_users.select { |u| u.id.odd? }.map(&:id) }
      let!(:ids2) { different_company_users.select { |u| u.id.odd? }.map(&:id) }

      it 'ログインアカウントと同じ企業に紐づくアカウント内で指定したidのUserだけ返ること' do
        aggregate_failures do
          expect(searched_users.count).to eq 2
          expect(searched_users[0].id).to eq ids1[0]
          expect(searched_users[1].id).to eq ids1[1]
        end
      end
    end

    context 'emailで絞り込むとき' do
      let!(:user) { FactoryBot.create(:user, email: 'exist1@test.com', company: current_user.company) }

      before do
        FactoryBot.create(:user, email: 'exist2@test.com')
      end

      context '存在するemailで検索するとき' do
        let(:search_condition) { { email: 'exist' } }

        it 'ログインアカウントと同じ企業に紐づくアカウント内でヒットするメールアドレスのUserだけ返ること' do
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
      let!(:user) { FactoryBot.create(:user, :grader, company: current_user.company) }

      before do
        FactoryBot.create(:user, :not_grader)
        FactoryBot.create(:user, :grader)
      end

      it 'ログインアカウントと同じ企業に紐づくアカウント内で指定したフラグのUserだけ返ること' do
        aggregate_failures do
          expect(searched_users.count).to eq 2
          expect(searched_users[0].id).to eq current_user.id
          expect(searched_users[1].id).to eq user.id
        end
      end
    end
  end
end
