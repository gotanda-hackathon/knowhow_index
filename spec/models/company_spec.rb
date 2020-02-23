# frozen_string_literal: true

# == Schema Information
#
# Table name: companies # 利用企業テーブル
#
#  id           :bigint           not null, primary key
#  name(企業名) :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Company, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
