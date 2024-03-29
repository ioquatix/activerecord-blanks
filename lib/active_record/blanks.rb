# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

require_relative "blanks/version"

module ActiveRecord
	module Blanks
		def blank_columns
			return to_enum(:blank_columns) unless block_given?
			
			self.class.columns.each do |column|
				if column.null
					yield column
				end
			end
		end
		
		def convert_blanks(to = nil)
			blank_columns do |column|
				value = read_attribute(column.name)
				
				next unless value.is_a?(String)
				
				# Strip leading and trailing whitespace:
				value = value.strip
				
				if value.blank?
					write_attribute(column.name, to)
				else
					write_attribute(column.name, value)
				end
			end
		end
		
		def self.prepended(base)
			base.before_validation :convert_blanks
		end
	end
end
