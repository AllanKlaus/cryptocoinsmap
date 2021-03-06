class WelcomeController < ApplicationController
  def index
    @addresses = nil
    if params[:filter_countries]
      f_countries = params[:filter_countries]
      @addresses = Address.from_countries(f_countries)
    else
      @addresses = Address.all
    end
    @countries = Country.all.order(:name_en)
    @crypto_currencies = CryptoCurrency.all
    @languages = Language.all
    @categories = Category.all
    @hash = Gmaps4rails.build_markers(@addresses) do |address, marker|
      marker.lat address.latitude
      marker.lng address.longitude
      marker.picture({
                         "url" => "http://localhost:3000#{ActionController::Base.helpers.asset_path('marker.png')}",
                         "width" =>  32,
                         "height" => 32
                     })

      info_window_html = "<div class=\"countainer-fluid\">"+
                          "<h5><a href=\"http://localhost:3000/addresses/#{address.id}\">#{address.business_name}</a></h5>"+
                          "<div>"+ #bussiness categories
                            "<div class=\"infobox-tag-icon\"> </div>"+
                            "<div class=\"address_property_value\">Food, Barbecue</div>"+
                          "</div>"+
                          "<div >"+#state and country
                            "<div class=\"infobox-flag-icon\"> </div>"+
                            "<div class=\"address_property_value\">#{address.city}, #{address.state}, #{address.country.name} </div>"+
                          "</div>"+
                          "<div>"+ #full street address (street, number, complement)
                            "<div class=\"infobox-street-icon\"> </div>"+
                            "<div class=\"address_property_value\">#{address.full_street} </div>"+
                          "</div>"
      #add crypyo phone numbers to infowindow
      address.phone_numbers.each do |pn|
        info_window_html += "<div>"+
                            "<div class=\"infobox-phone-icon\"> </div>"+
                            "<div class=\"address_property_value\">#{pn}</div>"+
                            "</div>"
      end
      #add crypyo emails to infowindow
      address.emails.each do |em|
        info_window_html += "<div>"+
            "<div class=\"infobox-email-icon\"> </div>"+
            "<div class=\"address_property_value\">#{em} </div>"+
                            "</div>"
      end
      #add crypyo currencies to infowindow
      info_window_html += "<div id=\"accepted-coins\" >"

      address.crypto_currencies_accepted.each do |coin_accepted|
        info_window_html +=  "<img class=\"infobox-currency-logo-16x16\" alt=\"#{coin_accepted}\" src=\"http://localhost:3000#{ActionController::Base.helpers.asset_path("coins_icons/#{coin_accepted.split.join('-')}")}\" > </img>"
      end
      info_window_html += "</div>" #close accepted-coins
      info_window_html += "</div>" #close container-fluid
      marker.infowindow info_window_html
    end
  end
  def report

    end
  def donate

  end
end
