require "option_parser"
require "http/client"
require "file_utils"
require "./day/*"

module Aoc
  VERSION = "0.1.0"

  days = {
    "1" => Day1,
  }
  name_of_day = nil

  OptionParser.parse do |parser|
    parser.banner = "Usage: aoc [arguments]"
    parser.on("-d DAY", "--day=DAY", "The day to run tests for") { |d| name_of_day = d }
    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end
    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
    end
  end

  name_of_day = Time.local.day.to_s unless name_of_day
  day = (days[name_of_day || ""] || raise "Invalid day chosen").new

  session = begin
    (File.read ".session").strip
  rescue
    raise "You must put your session in the `.session` file"
  end

  data = get_data_for_day(name_of_day, session)

  puts "First Solution: #{day.first(data)}\n"
  puts "Second Solution: #{day.second(data)}\n"

  def self.get_data_for_day(day, session)
    FileUtils.mkdir_p ".data/"
    file_name = ".data/#{day}"

    if File.exists? file_name
      return (File.read file_name).lines.to_a
    end

    url = "https://adventofcode.com/2020/day/#{day}/input"
    headers = HTTP::Headers.new
    headers["cookie"] = "session=#{session}"
    response = HTTP::Client.get url, headers
    File.write file_name, response.body

    response.body.lines.to_a
  end
end
