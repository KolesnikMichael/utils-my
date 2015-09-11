require 'pry'


sms_no_date = File.read("sms-no-date.txt").split("\n")

sms_to_import = File.open("sms-timestamps.txt", "w") do |file|
  sms_no_date.each do |item|
    timestamp = /readable_date="(.+)"\sc/.match(item)[1]
    year = /.(\d+)\s/.match(timestamp)[1].to_i
    month = /.(\d\d)./.match(timestamp)[1].to_i
    day = /(\d\d)./.match(timestamp)[1].to_i
    hours = /\s(\d+):/.match(timestamp)[1].to_i
    minutes = /:(\d+):/.match(timestamp)[1].to_i
    seconds = /\d:\d+:(\d+)/.match(timestamp)[1].to_i
    timestamp_millis = Time.new(year.to_i, month, day, hours, minutes, seconds, "+03:00").to_i.to_s + "000"
    file << timestamp_millis + "\n"
  end
end
