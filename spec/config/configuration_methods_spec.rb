require "rails_helper"

RSpec.describe Jinrai::ConfigurationMethods do
  before do
    20.times do |i|
      User.create!(name: "user%03d" % i)
    end
    Jinrai.instance_variable_set("@config", Jinrai::Config.new)
  end

  after do
    %w[
      @_default_cursor_per
      @_default_cursor_format
      @_default_cursor_sort_order
    ].each do |val|
      User.instance_variable_set(val, nil)
    end
  end

  describe "#cursor_per" do

    subject { User.instance_variable_get("@_default_cursor_per") }
    context "non int argument" do
      before do
        User.cursor_per "foobar"
      end

      it "should be set 0" do
        is_expected.to eq 0
      end

      it "should return 0 record" do
        expect(User.cursor.count).to eq 0
      end
    end

    context "int argument" do
      before do
        User.cursor_per 10
      end

      it "should be 10" do
        is_expected.to eq 10
      end

      it "should return 10 records" do
        expect(User.cursor.count).to eq 10
      end
    end
  end

  describe "#cursor_format" do
    subject { User.instance_variable_get("@_default_cursor_format") }
    before do
      User.cursor_format :id, :name
    end

    it "should be set :id :name" do
      is_expected.to eq [:id, :name]
    end
  end

  describe "#cursor_sort_order" do
    subject { User.instance_variable_get("@_default_cursor_sort_order") }
    context ":asc" do
      before { User.cursor_sort_order :asc }
      it "should be set :asc" do
        is_expected.to eq :asc
      end

      it "first record id should lower than second record id" do
        expect(User.cursor.first.id).to be < User.cursor.second.id
      end
    end

    context ":desc" do
      before { User.cursor_sort_order :desc }
      it "should be set :desc" do
        is_expected.to eq :desc
      end

      it "first record id should greater than second record id" do
        expect(User.cursor.first.id).to be > User.cursor.second.id
      end
    end
  end

  describe ".default_cursor_per" do
    subject { User.default_cursor_per }
    context "by default" do
      it "should be 20" do
        is_expected.to eq 20
      end
    end

    context "configure via model block" do
      before { User.cursor_per 10 }
      it "should be 10" do
        is_expected.to eq 10
      end
    end
  end

  describe ".default_cursor_format" do
    subject { User.default_cursor_format }
    context "by default" do
      it "should be [:created_at, :id]" do
        is_expected.to eq [:created_at, :id]
      end
    end

    context "configure via model block" do
      before { User.cursor_format :name, :age }

      it "should be [:name, age]" do
        is_expected.to eq [:name, :age]
      end
    end
  end

  describe ".default_cursor_sort_order" do
    subject { User.default_cursor_sort_order }
    context "by default" do
      it "should be desc" do
        is_expected.to eq :desc
      end
    end

    context "configure via model block" do
      before { User.cursor_sort_order :asc }
      it "should be asc" do
        is_expected.to eq :asc
      end
    end
  end
end
