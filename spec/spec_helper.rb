require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.dirname(__FILE__)
require "rspec"
require "money"

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

I18n.enforce_available_locales = false

RSpec.configure do |c|
  c.order = :random
  c.filter_run :focus
  c.run_all_when_everything_filtered = true
end

def reset_i18n
  I18n.backend = I18n::Backend::Simple.new
end

RSpec.shared_context 'with i18n locale backend', :i18n do
  around do |example|
    previous_locale_backend = Money.locale_backend
    Money.locale_backend = :i18n

    example.run

    Money.locale_backend = Money::LocaleBackend::BACKENDS.key(previous_locale_backend.class)
  end
end

RSpec.shared_context "with infinite precision", :infinite_precision do
  before do
    Money.infinite_precision = true
  end

  after do
    Money.infinite_precision = false
  end
end
