#!/usr/bin/env ruby

require 'haml'
require 'cgi'

class GedToXml
  attr_accessor :source, :intermediate, :result

  def initialize(source)
    @source = source
    @intermediate = []
  end

  def parse
    # convert GED to hashes
    File.foreach(source) do |line|
      line.chomp!
      next if line.empty?
      intermediate << extract_data(line)
    end
    
    # convert hash to HAML
    File.open('_intermediate.haml', 'w') do |f|
      f.puts "!!! XML \n"
      intermediate.each_with_index do |h, i|
        next_elem = intermediate[i + 1]
        indent = 2 * h.fetch(:level).to_i
        data = CGI.escapeHTML(h.fetch(:data) || "")
        id = h.fetch(:id) ? "(id='#{h.fetch(:id)}')" : ""
        if has_children?(h, next_elem)
          f.puts "#{" " * indent}%#{h.fetch(:tag).downcase}#{id}\n#{" " * (indent + 2)}#{data}"
        else
          f.puts "#{" " * indent}%#{h.fetch(:tag).downcase}#{id} #{data}"
        end
      end
    end
    
    # convert HAML to XML
    engine = Haml::Engine.new(File.read('_intermediate.haml'), {format: :xhtml})
    engine.render
  end

  private

  def extract_data(line)
    # Regex built with the help of Rubular http://rubular.com/r/I65tSawMyw
    matches = /\A(\d+)\s+(@[\w]+@)?\s?([A-Z]+)\s?(.+)?/.match(line)
    {
      level: matches[1],
      id: matches[2],
      tag: matches[3],
      data: matches[4]
    }
  end

  def has_children?(current_elem, next_elem)
    return false unless current_elem && next_elem
    next_elem.fetch(:level) > current_elem.fetch(:level)
  end
end

# expected format ./gedcom.rb source.ged
unless ARGV.size == 2 && test(?e, ARGV[0]) && (File.extname(ARGV[0]) == ".ged")
  puts "Usage: #{$PROGRAM_NAME} GED_SOURCE.ged DESTINATION"
  exit
end

file = ARGV[0]
destination = ARGV[1]

parser = GedToXml.new(file)
result = parser.parse 
File.write("#{destination}.xml", result)

# Format: 
# LEVEL TAG-OR-ID [DATA]
# 0 @I1@ INDI
# 1 NAME Jamis Gordon /Buck/ 
# 2 SURN Buck
# 2 GIVN Jamis Gordon
# 1 SEX M