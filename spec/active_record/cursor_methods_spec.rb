require 'rails_helper'

RSpec.describe Jinrai::ActiveRecord::CursorMethods do
  before do
    create_list(:user, 10)
    User.cursor_per 10
    User.cursor_format :id, :name
  end

  describe "#since_cursor" do
    subject do
      User.send(:decode_cursor, users.since_cursor)
    end

    let(:users) { User.cursor }
    let(:user) { users.first }
    let(:attributes) do
      { id: user.id.to_s, name: user.name.to_s }
    end

    it "should include correct value" do
      is_expected.to match(attributes)
    end
  end

  describe "#till_cursor" do
    subject do
      User.send(:decode_cursor, users.till_cursor)
    end

    let(:users) { User.cursor }
    let(:user) { users.last }
    let(:attributes) do
      { id: user.id.to_s, name: user.name.to_s }
    end

    it "should include correct value" do
      is_expected.to match(attributes)
    end
  end
end
