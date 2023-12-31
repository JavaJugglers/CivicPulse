# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  # new attributes
  # validates :street, :city, :state, :zip, :party, presence: true

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_title = get_division_title(rep_info, index)

      addr = get_addr(official)

      rep = Representative.find_or_create_by!(
        name:   official.name,
        ocdid:  ocdid_title[0],
        title:  ocdid_title[1],
        street: addr[0],
        city:   addr[1],
        state:  addr[2],
        zip:    addr[3]
      )
      edit_params(official, rep)
      reps.push(rep)
    end

    reps
  end

  def self.get_division_title(rep_info, index)
    ocdid_temp = ''
    title_temp = ''

    rep_info.offices.each do |office|
      if office.official_indices.include? index
        title_temp = office.name
        ocdid_temp = office.division_id
      end
    end

    [ocdid_temp, title_temp]
  end

  def self.edit_params(official, rep)
    if official.party.present? && official.party != rep.party
      rep.party = official.party
      rep.save
    end

    return unless official.photo_url.present? && official.photo_url != rep.photo_url

    rep.photo_url = official.photo_url
    rep.save
  end

  def self.get_addr(official)
    street_temp = ''
    city_temp = ''
    state_temp = ''
    zip_temp = ''
    unless official.address.nil?
      addr = official.address[0]
      street_temp = addr.line1
      street_temp += " #{addr.line2}" unless addr.line2.nil?
      street_temp += " #{addr.line3}" unless addr.line3.nil?
      city_temp = addr.city
      state_temp = addr.state
      zip_temp = addr.zip
    end

    [street_temp, city_temp, state_temp, zip_temp]
  end
end
