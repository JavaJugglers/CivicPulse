# frozen_string_literal: true

require 'google/apis/civicinfo_v2'

class SearchController < ApplicationController
  def search
    address = params[:address]
    service = Google::Apis::CivicinfoV2::CivicInfoService.new
    service.key = Rails.application.credentials[:GOOGLE_API_KEY]

    begin
      result = service.representative_info_by_address(address: address)
    rescue Google::Apis::ClientError
      flash[:notice] = 'Please enter a valid address.'
      redirect_to representatives_path
      return
    else
      @representatives = Representative.civic_api_to_representative_params(result)
    end

    render 'representatives/search'
  end
end
