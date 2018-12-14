require "rails_helper"

RSpec.describe Jinrai::Config do
  describe "default_cursor_per" do
    subject { Jinrai.config.default_cursor_per }
    context "by default" do
      it "should be 20" do
        is_expected.to eq 20
      end
    end

    context "configure via confilg block" do
      before do
        Jinrai.configure do |config|
          config.default_cursor_per = 100
        end
      end

      it "should be 100" do
        is_expected.to eq 100
      end
    end
  end

  describe "default_cursor_format" do
    subject { Jinrai.config.default_cursor_format }
    context "by default" do
      it "should be [:created_at, :id]" do
        is_expected.to eq [:created_at, :id]
      end
    end

    context "configure via config block" do
      before do
        Jinrai.configure do |config|
          config.default_cursor_format = :created_at, :updated_at
        end
      end

      it "should be [:created_at, :updated_at]" do
        is_expected.to eq [:created_at, :updated_at]
      end
    end
  end

  describe "default_cursor_sort_order" do
    subject { Jinrai.config.default_cursor_sort_order }
    context "by default" do
      it "should be desc" do
        is_expected.to eq :desc
      end
    end

    context "configure via config block" do
      before do
        Jinrai.configure do |config|
          config.default_cursor_sort_order = :asc
        end
      end
      it "should be asc" do
        is_expected.to eq :asc
      end
    end
  end
end
