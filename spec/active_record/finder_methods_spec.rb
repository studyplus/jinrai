require "rails_helper"

RSpec.describe Jinrai::ActiveRecord::FinderMethods do
  before do
    travel_to(Time.zone.now)

    User.cursor_per 2
    create(:user, age: 5)
    create(:user, age: 4)
    create(:user, age: 3)
    create(:user, age: 2)
    create(:user, age: 1)
  end

  describe ".cursor" do
    context "when sort at primary(id)" do
      it "should return correct collection" do
        users = User.cursor
        _users = User.where(age: [1, 2]).order(id: :desc)

        expect(users.count).to eq(2)
        expect(users).to contain_exactly(*_users)

        # steps for checking passing since parameter
        since_cursor = users.till_cursor

        users  = User.cursor(since: since_cursor)
        _users = User.where(age: [3, 4]).order(id: :desc)

        expect(users.count).to eq(2)
        expect(users).to contain_exactly(*_users)

        # steops for checking passing till parameter
        till_cursor = users.since_cursor

        users  = User.cursor(till: till_cursor)
        _users = User.where(age: [1, 2]).order(id: :desc)

        expect(users.count).to eq(2)
        expect(users).to contain_exactly(*_users)
      end
    end

    context "when sort at NOT primary" do
      it "should return correct collection" do
        users  = User.cursor(sort_at: :age)
        _users = User.where(age: [5, 4]).order(age: :desc)

        expect(users.count).to eq(2)
        expect(users).to contain_exactly(*_users)

        # steps for checking passing since parameter
        since_cursor = users.till_cursor

        users = User.cursor(since: since_cursor, sort_at: :age)
        _users = User.where(age: [3, 2]).order(age: :desc)

        expect(users.count).to eq(2)
        expect(users).to contain_exactly(*_users)

        # steps for checing passing since parameter
        till_cursor = users.since_cursor

        users = User.cursor(till: till_cursor, sort_at: :age)
        _users = User.where(age: [5, 4]).order(age: :desc)

        expect(users.count).to eq(2)
        expect(users).to contain_exactly(*_users)
      end
    end

    context "cursor has attribute which is inexistence in database" do
      context "if not defined how to decode cursor to record attributes" do
        before do
          User.cursor_format :created_at_human, :id
        end

        it "should raise Jinrai::ActiveRecord::StatementInvalid" do
          cursor = User.cursor.till_cursor
          expect { User.cursor(since: cursor) }.to raise_error(Jinrai::ActiveRecord::StatementInvalid)
        end
      end

      context "if defined how to decode cursor to record attributes but no record found" do
        before do
          User.cursor_format :created_at_human, :id do |attributes|
            {
              created_at: Time.zone.tomorrow,
              id: attributes[:id]
            }
          end
        end

        it "should raise Jinrai::ActiveRecord::RecordNotFound" do
          cursor = User.cursor.till_cursor
          expect { User.cursor(since: cursor) }.to raise_error(Jinrai::ActiveRecord::RecordNotFound)
        end
      end

      context "if defined how to decode cursor to record attributes" do
        before do

          User.cursor_format :created_at_human, :id do |attributes|
            {
              created_at: Time.zone.parse(attributes[:created_at_human]),
              id: attributes[:id]
            }
          end
        end

        it "should raise Jinrai::ActiveRecord::RecordNotFound" do
          cursor = User.cursor.till_cursor
          users = User.cursor(since: cursor)
          _users = User.where(age: [3, 4]).order(id: :desc)

          expect(users.count).to eq(2)
          expect(users).to contain_exactly(*_users)
        end
      end
    end
  end
end
