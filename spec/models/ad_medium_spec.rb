# frozen_string_literal: true

# == Schema Information
#
# Table name: ad_media # 広告媒体マスターテーブル
#
#  id                 :bigint           not null, primary key
#  name(媒体名)       :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id(企業ID) :bigint           not null
#
# Indexes
#
#  index_ad_media_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe AdMedium, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
