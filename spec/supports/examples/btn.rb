# frozen_string_literal: true

RSpec.shared_examples 'ボタンエクスペクテーション：be_able_to_new' do
  it '新規作成ボタンが存在すること' do
    expect(page).to have_link '新規作成'
  end
end

RSpec.shared_examples 'ボタンエクスペクテーション：not_be_able_to_new' do
  it '新規作成ボタンが存在しないこと' do
    expect(page).not_to have_link '新規作成'
  end
end

RSpec.shared_examples 'ボタンエクスペクテーション：not_be_able_to_edit' do
  it '編集ボタンが存在しないこと' do
    expect(page).not_to have_link '編集'
  end
end

RSpec.shared_examples 'ボタンエクスペクテーション：not_be_able_to_destroy' do
  it '削除ボタンが存在しないこと' do
    expect(page).not_to have_link '削除'
  end
end

RSpec.shared_examples 'ボタンエクスペクテーション：be_able_to_csv_import' do
  it 'CSV取込ボタンが存在すること' do
    expect(page).to have_button 'CSV取込'
  end
end

RSpec.shared_examples 'ボタンエクスペクテーション：not_be_able_to_csv_import' do
  it 'CSV取込ボタンが存在しないこと' do
    expect(page).not_to have_button 'CSV取込'
  end
end

RSpec.shared_examples 'ボタンエクスペクテーション：be_able_to_csv_export' do
  it 'CSV出力ボタンが存在すること' do
    expect(page).to have_link 'CSV出力'
  end
end

RSpec.shared_examples 'ボタンエクスペクテーション：not_be_able_to_csv_export' do
  it 'CSV出力ボタンが存在しないこと' do
    expect(page).not_to have_link 'CSV出力'
  end
end
