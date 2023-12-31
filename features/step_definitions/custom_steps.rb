# frozen_string_literal: true

# Add any necessary steps for testing
When /I create a state and county$/ do
  State.create!(name:         'example_state',
                symbol:       'ES',
                fips_code:    1,
                is_territory: 1,
                lat_min:      1.0,
                lat_max:      1.0,
                long_min:     1.0,
                long_max:     1.0)
  County.create!(name:       'example_county',
                 state:      State.first,
                 fips_code:  2,
                 fips_class: 'example_class')
end

When /I create a new event$/ do
  Event.create!(
    name:        'chips 10.5',
    description: 'trying to get 85 percent coverage',
    start_time:  10.days.from_now,
    end_time:    20.days.from_now,
    county:      County.first
  )
end
