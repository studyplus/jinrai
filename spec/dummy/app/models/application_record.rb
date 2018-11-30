class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  cursor_per 20
end
