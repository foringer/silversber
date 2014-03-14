# coding: utf-8

require 'rubygems'
require 'nokogiri' 
require 'open-uri'

def get_trade
  page = Nokogiri::HTML(open("http://www.sberbank.ru/moscow/ru/quotes/metal/"))   
  #puts page.css("title").text 
  #page.css("td").each do |value|
  #  puts page.text
  #end
  all_td = page.css("td")[0].text
  array_td = all_td.split
  trade_date = array_td[4].chomp
  trade_buy =  array_td[8].chomp
  trade_sell =  array_td[9].chomp
  trade_line = trade_date + "\t\t" + trade_buy + "\t\t" + trade_sell
  return trade_line
end

curr =  get_trade

def save_trade
  silver_file = File.open("/tmp/silver.txt", "a+")
  silver_file.puts get_trade
  silver_file.close
end

def check_changes (trade_line)
  file = File.open("/tmp/silver.txt")
  line = file.gets.chomp
  file.close
  if ( line == trade_line )
    #puts "Курс не изменился" 
    return false
  else
    #puts "Курс поменялся"
    return true
  end
end

if  check_changes(curr)
  puts "Курс поменялся\t\tПокупка\t\tПродажа"
  puts curr + "\n"
  f = File.open("/tmp/silver.txt")
  lines = f.readlines
  f.close

  newcurr = curr + "\n"

  lines = [ newcurr ] + lines

  newfile = File.open("/tmp/silver.txt", "w")
  lines.each { |line| newfile.write line }
  newfile.close
else
  puts "Курс не изменился\t\tПокупка\t\tПродажа"
  file = File.open("/tmp/silver.txt")
  puts file.gets
  file.close
end

