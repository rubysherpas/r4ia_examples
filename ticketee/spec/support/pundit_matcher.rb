RSpec::Matchers.define :permit_action do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message do |policy|
    "#{policy.class} does not allow #{policy.user || "nil"} to " +
      "perform :#{action}? on #{policy.record}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid #{policy.user || "nil"} from " +
      "performing :#{action}? on #{policy.record}."
  end
end
