require "rails_helper"

RSpec.describe Jinrai::ActiveRecord::Core do
  subject { Class.new(ActiveRecord::Base) }
  it "ActiveRecord::Base should respond Jinrai defined methods" do
    if defined?(ActiveRecord)
      is_expected.to respond_to(:cursor, :after, :before)
    end
  end
end
