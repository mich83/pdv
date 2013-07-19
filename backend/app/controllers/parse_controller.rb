# -*- encoding : utf-8 -*-
class ParseController < ApplicationController
	def index
		file = params[:file].tempfile
		Spreadsheet.client_encoding = 'UTF-8'
		wb = Spreadsheet.open(file)
		wb.encoding = 'CP1251'
		
		ws = wb.worksheet(0)
		res = []
		24.upto ws.last_row_index do |index|
			row = ws.row(index)
			item = row[3]
			unless item.nil?
				#s_item = item.split(':')
				#title = s_item[s_item.size-1]
				item_name = item.tr('"','`').tr("'",'')
				obj = Good.where(:name=>item_name).first
				
				res.push({:item=>item_name,:qty=>row[20],:price=>row[25],:total=>row[29],:item_obj=>if obj.nil? then nil else obj.id end,:item_title=>if obj.nil? then nil else obj.name end})
			end
		end
		render :json => {:data => res , :success=>true}
	end
	
	def new
	end
	
	def create
	end
	
	def destroy
	end
	private
end
