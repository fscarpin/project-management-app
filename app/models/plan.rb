class Plan

  PLANS = [:free, :premium]

  def self.get_options
    options = Array.new
    PLANS.each { |plan| options << [plan.capitalize, plan] }

    return options
  end
end
