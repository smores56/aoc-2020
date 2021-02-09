require "option_parser"
require "http/client"
require "file_utils"
require "./day/*"

module Aoc
  DAYS = {
    "1"  => Day1,
    "2"  => Day2,
    "3"  => Day3,
    "4"  => Day4,
    "5"  => Day5,
    "6"  => Day6,
    "7"  => Day7,
    "8"  => Day8,
    "9"  => Day9,
    "10" => Day10,
    "11" => Day11,
    "12" => Day12,
    "13" => Day13,
    "14" => Day14,
    "15" => Day15,
    "16" => Day16,
    "17" => Day17,
    "18" => Day18,
    "19" => Day19,
    "20" => Day20,
    "21" => Day21,
    "22" => Day22,
    "23" => Day23,
    "24" => Day24,
    "25" => Day25,
  }

  name_of_day = nil

  OptionParser.parse do |parser|
    parser.banner = "Usage: aoc-2020 [arguments]"
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
  day = (DAYS[name_of_day]? || raise "Invalid day chosen").new

  session = begin
    (File.read ".session").strip
  rescue
    raise "You must put your session in the `.session` file"
  end

  data = get_data_for_day(name_of_day, session)

  t1 = Time.monotonic
  first = day.first(data)
  t2 = Time.monotonic
  puts "First Solution: #{first} (took #{(t2 - t1).to_f} seconds)\n"

  second = day.second(data)
  t3 = Time.monotonic
  puts "Second Solution: #{second} (took #{(t3 - t2).to_f} seconds)\n"

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
