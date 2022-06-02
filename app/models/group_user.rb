class GroupUser < ApplicationRecord
  t.references  :user,  index: true, foreign_key: true
  t.references  :group, index: true, foreign_key: true
end
