require "rails_helper"

RSpec.describe Jinrai::ActiveRecord::FinderMethods do
  before do
    User.cursor_per 3

    now = Time.zone.now
    create(:user, age: 5, updated_at: now)
    create(:user, age: 4, updated_at: now + 2.second)
    create(:user, age: 3, updated_at: now + 1.second)
    create(:user, age: 2, updated_at: now + 1.second)
    create(:user, age: 1, updated_at: now + 2.second)

    create(:user, age: 4, updated_at: now)
    create(:user, age: 5, updated_at: now)
  end

  describe ".cursor" do
    shared_examples_for "return correct collection" do
      it "should return correct collection" do
        users1 = User.cursor(order: order)
        _users1 = User.order(order).limit(3)

        expect(users1.ids).to eq _users1.ids

        # steps for checking passing since parameter
        since_cursor1 = users1.till_cursor

        users2  = User.cursor(since: since_cursor1, order: order)
        _users2 = User.where.not(id: _users1.ids).order(order).limit(3)

        expect(users2.ids).to eq _users2.ids

        since_cursor2 = users2.till_cursor

        users3  = User.cursor(since: since_cursor2, order: order)
        _users3 = User.where.not(id: (_users1.ids + _users2.ids)).order(order).limit(3)

        expect(users3.count).to eq 1
        expect(users3.ids).to eq _users3.ids


        # steps for checking passing till parameter
        till_cursor2 = users2.since_cursor

        till_users  = User.cursor(till: till_cursor2, order: order)
        _till_users = User.order(order).limit(3)

        expect(till_users.ids).to eq _till_users.ids
      end
    end

    context "when sort at one attribute" do
      let(:order) { { id: :desc } }
      it_behaves_like "return correct collection"
    end

    context "when sort at dpuble attributes" do
      let(:order) { { age: :desc, id: :asc } }
      it_behaves_like "return correct collection"
    end

    context "when sort at triple attributes" do
      let(:order) { { age: :desc, updated_at: :asc, id: :desc } }
      it_behaves_like "return correct collection"
    end

    context "when sort without id" do
      shared_examples_for "return all collection" do
        it "should return all data" do
          users1 = User.cursor(order: order)
          expect(users1.count).to eq 3

          users2  = User.cursor(since: users1.till_cursor, order: order)
          expect(users2.count).to eq 3

          users3  = User.cursor(since: users2.till_cursor, order: order)
          expect(users3.count).to eq 1

          expect((users1.ids + users2.ids + users3.ids)).to eq User.order(order.merge(id: :asc)).ids
        end
      end

      context "when sort at one attribute" do
        let(:order) { { age: User.default_cursor_sort_order } }
        it_behaves_like "return all collection"
        it "should return same collection from withour multiple orders" do
          users_with_multiple_orders1 = User.cursor(order: order)
          users_without_multiple_orders1 = User.cursor(sort_at: :age)
          expect(users_with_multiple_orders1.ids).to eq users_without_multiple_orders1.ids

          users_with_multiple_orders2 = User.cursor(since: users_with_multiple_orders1.till_cursor, order: order)
          users_without_multiple_orders2 = User.cursor(since: users_without_multiple_orders1.till_cursor, sort_at: :age)
          expect(users_with_multiple_orders2.ids).to eq users_without_multiple_orders2.ids

          users_with_multiple_orders3 = User.cursor(since: users_with_multiple_orders2.till_cursor, order: order)
          users_without_multiple_orders3 = User.cursor(since: users_without_multiple_orders2.till_cursor, sort_at: :age)
          expect(users_with_multiple_orders3.ids).to eq users_without_multiple_orders3.ids
        end
      end

      context "when sort at multiple attributes" do
        let(:order) { { age: :desc, updated_at: :asc } }
        it_behaves_like "return all collection"
      end
    end

    context "Invalid call" do
      it "should raise error" do
        expect { User.cursor(order: { id: :desc }, sort_at: :age) }.to raise_error(ArgumentError)
        expect { User.order(age: :desc).cursor(order: { id: :desc }) }.to raise_error(RuntimeError, "Cannot use order method before cursor/after/before methods")
      end
    end
  end

  describe ".after" do
    context "with multiple orders" do
      let(:order) { { age: :desc, id: :asc } }
      it "should return correct collection" do
        users1 = User.cursor(order: order)
        _users1 = User.order(order).limit(3)

        expect(users1.ids).to eq _users1.ids

        since_cursor1 = users1.till_cursor

        users2  = User.after(since_cursor1, order: order)
        _users2 = User.where.not(id: _users1.ids).order(order).limit(3)
        expect(users2.ids).to eq _users2.ids
      end
    end

    context "with multiple orders (but actually one attribute)" do
      let(:order) { { age: User.default_cursor_sort_order } }
      it "should return same collection from no multiple orders" do
        users_with_multiple_orders1 = User.cursor(order: order)
        users_without_multiple_orders1 = User.cursor(sort_at: :age)
        expect(users_with_multiple_orders1.ids).to eq users_without_multiple_orders1.ids

        users_with_multiple_orders2 = User.cursor(since: users_with_multiple_orders1.till_cursor, order: order)
        users_without_multiple_orders2 = User.after(users_without_multiple_orders1.till_cursor, sort_at: :age)
        expect(users_with_multiple_orders2.ids).to eq users_without_multiple_orders2.ids

        users_with_multiple_orders3 = User.cursor(since: users_with_multiple_orders2.till_cursor, order: order)
        users_without_multiple_orders3 = User.after(users_without_multiple_orders2.till_cursor, sort_at: :age)
        expect(users_with_multiple_orders3.ids).to eq users_without_multiple_orders3.ids
      end
    end
  end

  describe ".before" do
    context "with multiple orders" do
      let(:order) { { age: :desc, id: :asc } }
      it "should return correct collection" do
        users1 = User.cursor(order: order)
        users2  = User.cursor(since: users1.till_cursor, order: order)

        users = User.before(users2.since_cursor, order: order)
        expect(users.ids).to eq users1.ids
      end
    end

    context "with multiple orders (but actually one attribute)" do
      let(:order) { { age: User.default_cursor_sort_order } }
      it "should return same collection from no multiple orders" do
        users1 = User.cursor(order: order)
        users2  = User.cursor(since: users1.till_cursor, order: order)

        users_without_multiple_orders = User.before(users2.since_cursor, sort_at: :age)
        users_with_multiple_orders = User.before(users2.since_cursor, order: order)
        expect(users_without_multiple_orders.ids).to eq users_with_multiple_orders.ids
        expect(users_with_multiple_orders.ids).to eq users1.ids
      end
    end
  end
end
