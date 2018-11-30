# frozen_string_literal:true

require 'jinrai/active_model_serializers'

ActiveSupport.on_load :active_record do
  require 'jinrai/active_record/core'
  require 'jinrai/config'
  require 'jinrai/result'
  ActiveRecord::Relation.send(:prepend, Jinrai::Result)
  ActiveRecord::Base.send(:include, Jinrai::ActiveRecord::Core)
end
