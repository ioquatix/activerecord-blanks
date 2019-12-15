#!/usr/bin/env ruby

# Copyright, 2019, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'active_record'
require 'active_record/blanks'

RSpec.describe ActiveRecord::Blanks do
	before(:all) do
		ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
		
		ActiveRecord::Schema.define do
			create_table :users do |table|
				table.string :name, null: false, unique: true
				table.string :email, null: true
			end
		end
	end
	
	let(:model_class) do
		Class.new(ActiveRecord::Base) do
			self.table_name = "users"
			prepend ActiveRecord::Blanks
		end
	end
	
	let(:email) {"foo@bar.com"}
	
	it "shouldn't convert non-blank strings to nil" do
		model = model_class.new
		
		model.name = "test"
		model.email = email
		
		model.save!
		
		expect(model.email).to be == email
	end
	
	it "should convert blank strings to nil" do
		model = model_class.new
		
		model.name = "test"
		model.email = ""
		
		model.save!
		
		expect(model.email).to be_nil
	end
end
