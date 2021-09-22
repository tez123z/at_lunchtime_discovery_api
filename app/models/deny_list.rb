# frozen_string_literal: true

class DenyList < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
  self.table_name = 'deny_list'
end
