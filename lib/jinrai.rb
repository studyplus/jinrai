# frozen_string_literal:true

require 'jinrai/active_record/result'
require 'jinrai/config'
require 'jinrai/configuration_methods'

ActiveSupport.on_load :active_record do
  require 'jinrai/active_record/core'
  ActiveRecord::Relation.send(:prepend, Jinrai::ActiveRecord::Result)
  ActiveRecord::Base.send(:include, Jinrai::ActiveRecord::Core)
end

module Jinrai
end
