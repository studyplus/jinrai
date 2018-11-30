require "rails_helper"

RSpec.describe Jinrai::ActiveRecord::FinderMethods do
  before do
    User.cursor_per 20
    1.upto(100) do |i|
      User.create(id: i, name: "user#{'%03d' % i}", age: (102 - i)/2.to_i)
    end
  end

  User.define_method(:to_cursor) do
    cursor_format = self.class.default_cursor_format
    attributes = cursor_format.map do |attribute|
      self.send(attribute)
    end
    Base64.urlsafe_encode64(attributes.join("_"))
  end

  describe ".cursor" do
    context "sorted at primary key" do
      context "sorted by desc" do
        context "passed nothing argument" do
          let(:users) { User.cursor }
          it "should be return correct 20 records" do
            expect(users.count).to eq 20
            expect(users.first.id).to eq 100
            expect(users.last.id).to eq 81
          end
        end

        context "passed since cursor" do
          let(:since) { User.find(81).to_cursor }
          let(:users) { User.cursor(since: since) }
          it "should be return correct 20 records" do
            expect(users.count).to eq 20
            expect(users.first.id).to eq 80
            expect(users.last.id).to eq 61
          end
        end

        context "passed till cursor" do
          let(:till) { User.find(100).to_cursor }
          let(:users) { User.cursor(till: till) }
          before do
          end
          it "should be return correct 20 records" do
            101.upto(110) do |i|
              User.create(id: i, name: "user#{'%03d' % i}", age: (101 - i)/2.to_i)
            end
            expect(users.count).to eq 10
            expect(users.first.id).to eq 110
            expect(users.last.id).to eq 101
          end
        end

        context "passed since && till cursor" do
          let(:since) { User.find(51).to_cursor }
          let(:till) { User.find(40).to_cursor }
          let(:users) { User.cursor(since: since, till: till) }
          it "should be return correct 10 records" do
            expect(users.count).to eq 10
            expect(users.first.id).to eq 50
            expect(users.last.id).to eq 41
          end
        end
      end

      context "sorted by asc" do
        before(:context) do
          User.cursor_sort_order :asc
        end
        context "passed nothing argument" do
          let(:users) { User.cursor }
          it "should be return correct 20 records" do
            expect(users.count).to eq 20
            expect(users.first.id).to eq 1
            expect(users.last.id).to eq 20
          end
        end

        context "passed since cursor" do
          let(:since) { User.find(10).to_cursor }
          let(:users) { User.cursor(since: since) }
          it "should be return correct 20 records" do
            expect(users.count).to eq 20
            expect(users.first.id).to eq 11
            expect(users.last.id).to eq 30
          end
        end

        context "passed till cursor" do
          let(:till) { User.find(11).to_cursor }
          let(:users) { User.cursor(till: till) }
          it "should be return correct 10 records" do
            expect(users.count).to eq 10
            expect(users.first.id).to eq 1
            expect(users.last.id).to eq 10
          end
        end

        context "passed since && till cursor" do
          let(:since) { User.find(10).to_cursor }
          let(:till) { User.find(21).to_cursor }
          let(:users) { User.cursor(since: since, till: till) }
          it "should be return correct 10 records" do
            expect(users.count).to eq 10
            expect(users.first.id).to eq 11
            expect(users.last.id).to eq 20
          end
        end
      end
    end

    context "sort_at: age" do
      before(:context) do
        User.cursor_format :age, :id
      end
      context "sorted by desc" do
        before(:context) do
          User.cursor_sort_order :desc
        end

        context "passed nothing cursor argument" do
          let(:users) { User.cursor(sort_at: :age) }
          it "should be return correct 20 records" do
            expect(users.count).to eq 20
            expect(users.first.age).to eq 50
            expect(users.last.age).to eq 41
            expect(users.first.id).to eq 1
            expect(users.last.id).to eq 20
          end
        end

        context "passed since cursor" do
          let(:since) { User.find(20).to_cursor }
          let(:users) { User.cursor(since: since, sort_at: :age) }
          it "should be return correct 20 records" do
            expect(users.count).to eq 20
            expect(users.first.age).to eq 40
            expect(users.last.age).to eq 31
            expect(users.first.id).to eq 21
            expect(users.last.id).to eq 40
          end
        end

        context "passed till cursor" do
          let(:till) { User.find(11).to_cursor }
          let(:users) { User.cursor(till: till, sort_at: :age) }
          before do
          end
          it "should be return correct 10 records" do
            expect(users.count).to eq 10
            expect(users.first.age).to eq 50
            expect(users.last.age).to eq 46
            expect(users.first.id).to eq 1
            expect(users.last.id).to eq 10
          end
        end

        context "passed since && till cursor" do
          let(:since) { User.find(10).to_cursor }
          let(:till) { User.find(21).to_cursor }
          let(:users) { User.cursor(since: since, till: till, sort_at: :age) }
          it "should be return correct 10 records" do
            expect(users.count).to eq 10
            expect(users.first.age).to eq 45
            expect(users.last.age).to eq 41
            expect(users.first.id).to eq 11
            expect(users.last.id).to eq 20
          end
        end
      end

      context "sorted by asc" do
        before(:context) do
          User.cursor_sort_order :asc
        end
        context "passed nothing argument" do
          let(:users) { User.cursor }
          it "should be return 20 records start with id: 1, and end with id: 20" do
            expect(users.count).to eq 20
            expect(users.first.id).to eq 1
            expect(users.last.id).to eq 20
          end
        end

        context "passed since cursor" do
          let(:since) { User.find(10).to_cursor }
          let(:users) { User.cursor(since: since) }
          it "should be return 20 records start with id: 11 and end with id: 30" do
            expect(users.count).to eq 20
            expect(users.first.id).to eq 11
            expect(users.last.id).to eq 30
          end
        end

        context "passed till cursor" do
          let(:till) { User.find(11).to_cursor }
          let(:users) { User.cursor(till: till) }
          it "should be return 20 records start with 1 and end with 10" do
            expect(users.count).to eq 10
            expect(users.first.id).to eq 1
            expect(users.last.id).to eq 10
          end
        end

        context "passed since && till cursor" do
          let(:since) { User.find(10).to_cursor }
          let(:till) { User.find(21).to_cursor }
          let(:users) { User.cursor(since: since, till: till) }
          it "should be return 10 records start with id: 11, end with 20" do
            expect(users.count).to eq 10
            expect(users.first.id).to eq 11
            expect(users.last.id).to eq 20
          end
        end
      end
    end
  end
end
