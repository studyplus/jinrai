require "rails_helper"

RSpec.describe Jinrai::ActiveRecord::Result do
  describe "#cursored?" do
    context "initialized" do
      it "should be false" do
        expect(User.all.cursored?).to be false
      end
    end

    context "cursored" do
      it "should be true" do
        expect(User.cursor.cursored?).to be true
      end
    end
  end
end
