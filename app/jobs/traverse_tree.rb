module TraverseTree
  @queue = :high
  def self.perform(user_id, current_test_datetime)
    user = User.find(user_id)
    user.traverse_sexual_partner_tree(current_test_datetime)
    user.update_attributes(tested_at: Time.now.utc)
  end
end