# frozen_string_literal: true

# == Schema Information
#
# Table name: creatives # 広告媒体マスターテーブル
#
#  id                     :bigint           not null, primary key
#  name(クリエイティブ名) :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  company_id(企業ID)     :bigint           not null
#
# Indexes
#
#  index_creatives_on_company_id           (company_id)
#  index_creatives_on_name_and_company_id  (name,company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe Creative, type: :model do
  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user) }

  describe '.csv_import!' do
    context '正しいCSVデータをインポートするとき' do
      it 'クリエイティブの作成に成功すること' do
        file = File.open(Rails.root.join('spec/fixtures/csvs/import_test_creative.csv'))
        aggregate_failures do
          expect { described_class.csv_import!(file, user) }.to change(described_class, :count).from(0).to(1)
          expect(described_class.first.name).to eq 'test_creative'
          expect(described_class.first.company).to eq user.company
        end
      end
    end
  end
end
