class Plan

  PLAN_FREE = :free
  PLAN_PREMIUM = :premium

  PLANS = [PLAN_FREE, PLAN_PREMIUM]

  def self.get_options
    options = Array.new
    PLANS.each { |plan| options << [plan.capitalize, plan] }

    return options
  end
end
