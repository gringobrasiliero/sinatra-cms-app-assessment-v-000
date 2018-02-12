module Functions

module Clock
def time
time = Time.now.strftime("%d/%m/%Y %H:%M")
  puts time
end

def time_hour
time_hour = Time.new
puts time_hour.hour
end

end #of clock

module Greeting

  def display_greeting

    if time_hour > 0 and time_hour < 12
      puts "Good Morning User.name"
      if time_hour > 12 and time_hour < 7
        puts "Good Afternoon User.name"
        if time_hour > 7 and time_hour < 24
          puts "Good Evening User.name"
    end


end #of Functions
