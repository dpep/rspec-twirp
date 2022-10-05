def expect_expectation_failure
  expect {
    RSpec::Mocks.with_temporary_scope { yield }
  }.to raise_error(RSpec::Mocks::MockExpectationError)
end
