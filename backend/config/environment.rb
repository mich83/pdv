# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Discount::Application.initialize!

Mime::Type.register "application/excel", :xls
