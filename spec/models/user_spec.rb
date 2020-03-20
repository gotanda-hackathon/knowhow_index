# frozen_string_literal: true

# == Schema Information
#
# Table name: users # ユーザーテーブル
#
#  id                          :bigint           not null, primary key
#  administrator(管理者フラグ) :boolean          default("false"), not null
#  email(メールアドレス)       :string           not null
#  grader(採点者フラグ)        :boolean          default("false"), not null
#  name(氏名)                  :string           not null
#  password_digest(パスワード) :string           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  company_id(企業ID)          :bigint           not null
#
# Indexes
#
#  index_users_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe '.csv_import!' do
    context '正しいCSVデータをインポートするとき' do
      # テスト用 csv ファイルに合わせた company を作成しておく
      let(:company) { FactoryBot.create(:company, id: 1) }
      let!(:user) { FactoryBot.create(:user, company: company) }

      it 'ユーザー作成に成功すること' do
        file = File.open(Rails.root.join('spec/fixtures/csvs/import_test_user.csv'))
        aggregate_failures do
          expect { described_class.csv_import!(file, user) }.to change(described_class, :count).from(1).to(2)
          expect(described_class.last.name).to eq 'test'
          expect(described_class.last.email).to eq 'tester@gmail.com'
          expect(described_class.last.company).to eq user.company
          expect(described_class.last.administrator).to eq true
          expect(described_class.last.grader).to eq true
        end
      end
    end
  end

  describe '#get_search_condition' do
    context 'paramsが空ハッシュのとき' do
      context 'current_userがまだ検索を行っていないとき' do
        it '空のハッシュを返すこと' do
          condition = user.get_search_condition(code: 'user', params: {})
          expect(condition).to eq({})
        end
      end

      context 'current_userが既に検索を行っているとき' do
        before do
          user.get_search_condition(code: 'user', params: { user_ids: ['1'] })
        end

        it '直前の検索条件を返すこと' do
          condition = user.get_search_condition(code: 'user', params: {})
          expect(condition[:user_ids]).to eq ['1']
        end
      end
    end

    context 'paramsが空ハッシュではないとき' do
      context 'current_userがまだ検索を行っていないとき' do
        it '検索条件が作られること' do
          expect do
            user.get_search_condition(code: 'user', params: { user_ids: ['1'] })
          end.to change(user.sql_conditions, :count).by(1)
        end

        it 'paramsと同じ値を返すこと' do
          condition = user.get_search_condition(code: 'user', params: { user_ids: ['1'] })
          expect(condition[:user_ids]).to eq ['1']
        end
      end

      context 'current_userが既に検索を行っているとき' do
        before do
          user.get_search_condition(code: 'user', params: { user_ids: ['1'] })
        end

        it 'paramsと同じ値を返すこと' do
          condition = user.get_search_condition(code: 'user', params: { user_ids: ['2'] })
          expect(condition[:user_ids]).to eq ['2']
        end

        it '既に行っていた検索条件を返さないこと' do
          condition = user.get_search_condition(code: 'user', params: { user_ids: ['2'] })
          expect(condition[:user_ids]).not_to eq ['1']
        end

        it '検索条件が増えないこと' do
          expect do
            user.get_search_condition(code: 'user', params: { user_ids: ['1'] })
          end.not_to change(user.sql_conditions, :count)
        end
      end
    end
  end
end
