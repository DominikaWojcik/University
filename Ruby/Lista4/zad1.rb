module Debugger
	def snapshot
		puts "Stan obiektu klasy #{self.class}"
		for iv in self.instance_variables
			puts "#{iv} = #{self.instance_variable_get(iv)}"
		end
		puts "\n"
	end

	def check
		puts "Wynik testów klasy #{self.class}"
		for testCase in self.methods
			if testCase.to_s.start_with?("test_") then
				puts "#{testCase.to_s} : #{self.method(testCase).call()}"
			end
		end
		puts "\n"
	end
end

class Drukarka

	include Debugger

	def initialize(name, info, moc)
		@name = name
		@info = info
		@moc = moc
	end

	def test_nazwy
		if @name.start_with?("HP") then
			"Test poprawny."
		else
			"Test niepoprawny: Niezgodna nazwa!"
		end
	end

	def test_mocy
		if 100 > @moc then
			"Test niepoprawny: Za mała moc!"
		elsif @moc > 400 then
			"Test niepoprawny: Za duża moc!"
		else 
			"Test poprawny"
		end
	end

	def test_poprawne_info
		if @info != nil then
			"Test poprawny"
		else 
			"Test niepoprawny: Info jest nilem!" 
		end
	end
end

drukarka1 = Drukarka.new("Canon S2422", "Jakies informacje", 420)
drukarka2 = Drukarka.new("HP Deskjet costam", nil, 200)
drukarka3 = Drukarka.new("HP A123g", "Informacje o modelu", 50)
drukarka4 = Drukarka.new("HP 53523T", "Info", 345)

drukarka1.snapshot
drukarka2.snapshot
drukarka3.snapshot
drukarka4.snapshot

drukarka1.check
drukarka2.check
drukarka3.check
drukarka4.check

