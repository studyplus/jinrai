require "rails_helper"

RSpec.describe Jinrai::ConfigurationMethods do
  describe "#cursor_per" do
    subject { User.instance_variable_get("@_default_cursor_per") }
    context "non int argument" do
      before do
        User.cursor_per "foobar"
      end

      it "should be set 0" do
        is_expected.to eq 0
      end
    end

    context "int argument" do
      before do
        User.cursor_per 10
      end

      it "should be 10" do
        is_expected.to eq 10
      end
    end
  end

  describe "#cursor_format" do
    subject { User.instance_variable_get("@_default_cursor_format") }
    before { User.cursor_format :id, :name }
    it "should be set array" do
      is_expected.to eq [:id, :name]
    end
  end

  describe "#cursor_sort_order" do
    subject { User.instance_variable_get("@_default_cursor_sort_order") }
    before { User.cursor_sort_order :asc }
    it "should be set :asc" do
      is_expected.to eq :asc
    end
  end

  describe "#cursor_record_id_extractor" do
    subject { User.instance_variable_get("@_default_cursor_record_id_extractor") }
    before { User.cursor_record_id_extractor(&block) }
    let(:block) { lambda { "test" } }

    it  "should be set block" do
      is_expected.to eq block
    end
  end
end
