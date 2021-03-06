# -*- encoding : utf-8 -*-
class PriceController < ApplicationController
def show
   @price = Price.where(:good_id=>params[:id],:price_type_id=>params[:pid]).pluck(:price)[0]
   render :json=>{:price=>@price,:target=>params[:target]}
end

def update
	price_type = PriceType.find(params[:price_type])
	data = params[:prices]
	result = '';
	data.each do |row|
		price = row[1][:price]
		good = Good.find(row[1][:good])
		elem = Price.where(:good_id=> good, :price_type_id=>price_type)
		if elem.any? then
			for_upd = elem.first
		else
			for_upd = Price.new
			for_upd.price_type = price_type
			for_upd.good = good
		end
		for_upd.price = price
		for_upd.save
	end
	render :json => {:result=>'Цены успешно обновлены'}
end

end
