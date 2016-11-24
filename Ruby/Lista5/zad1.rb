require "open-uri"
require "uri"

class Przegladarka

	def initialize
	end

	def przeglad(start_page, depth, &block)
		puts "Przegladanie " + start_page
		begin
			open(start_page, redirect:true) do | fh |
				html = fh.read
				block.call html	

				return if depth <= 0

				nextPages = html.scan(URI.regexp)
				nextPages.map! {|arr| arr.join("").gsub!(/http(s)?/, 'http\1://')}
				nextPages.select! {|str| str.is_a? String}

				nextPages.each do |page|
					przeglad(page, depth-1, &block)
				end

			end
		rescue OpenURI::HTTPError => var
			puts "Wyjatek: " + var.to_s, "\n"
		rescue SocketError => var
			puts "Wyjatek: " + var.to_s, "\n"
		rescue OpenURI::HTTPRedirect => redirect
			puts "\t Redirecting to  " + redirect.uri 
			start_page = redirect.uri
			retry
		rescue RuntimeError => var
			puts var.to_s, "\n"
		end
	end

	def page_weight(page)
		puts "PAGE WEIGHT " + page + ":\n"

		przeglad(page, 1) do |html|
			reg = /<(img|applet)/
			resourcesCount = html.scan(reg)
			puts resourcesCount[0]

			puts "Number of images or applets: " + resourcesCount.length.to_s + "\n"
		end

		puts "\nEND PAGE WEIGHT " + page + "\n"
	end

	def page_summary(page)
		puts "PAGE SUMMARY " + page + ":\n"
		
		przeglad(page, 1) do |html|
			reg = /<title>(.*)<\/title>/m
			if html =~ reg 
				puts "TITLE:", $1.to_s.strip.gsub(/\n|\t/m, ''), "\n"
			end	
		end

		puts "\nEND PAGE SUMMARY " + page + "\n"
	end 
end

a = Przegladarka.new()
#a.przeglad("http://ii.uni.wroc.pl", 4) {|str| puts "xD"}
a.page_weight("http://ii.uni.wroc.pl")
a.page_summary("http://ii.uni.wroc.pl")
