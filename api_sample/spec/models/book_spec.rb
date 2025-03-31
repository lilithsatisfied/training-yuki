# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string
#  author     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Book, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:book)).to be_valid
  end
end
