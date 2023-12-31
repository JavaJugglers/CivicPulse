# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    it 'updates existing representative' do
      # Create a representative that already exists in the database
      existing_representative = ret_rep

      # Define the representative information from the Civic API
      # rep_info = ret_rep_info

      # Call the method with the rep_info
      representatives = described_class.civic_api_to_representative_params(ret_rep_info)

      # Check that the existing representative was updated, not created anew
      expect(representatives.first.id).to eq existing_representative.id
      expect(representatives.first.party).to eq 'Democratic'
      expect(representatives.first.photo_url).to eq 'new_photo_url'
    end
  end

  def ret_rep_info
    OpenStruct.new(
      officials: [
        OpenStruct.new(
          name:      'John Doe',
          party:     'Democratic',
          photo_url: 'new_photo_url',
          address:   [OpenStruct.new(line1: '123 Main St', city: 'Anytown', state: 'NY', zip: '12345')]
        )
      ],
      offices:   [
        OpenStruct.new(
          name:             'Senator',
          division_id:      'existing-ocdid',
          official_indices: [0]
        )
      ]
    )
  end

  def ret_rep
    described_class.create!(
      name:   'John Doe',
      ocdid:  'existing-ocdid',
      title:  'Senator',
      party:  'Republican',
      street: '123 Main St',
      city:   'Anytown',
      state:  'NY',
      zip:    '12345'
    )
  end
end
