#!/usr/bin/env ruby

require "benchmark"
require "json"
require 'mixlib/cli'

class Results < Array
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean 
    sum / size
  end

  def percentile(percentile)
      values_sorted = self.sort
      k = (percentile*(values_sorted.length-1)+1).floor - 1
      f = (percentile*(values_sorted.length-1)+1).modulo(1)
      return values_sorted[k] + (f * (values_sorted[k+1] - values_sorted[k]))
  end

end


class Testfile
  include Mixlib::CLI

  def append filename
    Benchmark.realtime do 
      open(filename, 'a') do |f|
        f << '1'
      end
    end
  end

  def read filename
    Benchmark.realtime {`dd if=#{filename} of=/dev/null &> /dev/null`}
  end

  def run_test test_type
    results={
      cols: [
        {id: 'read_1', label: 'read_1', type: 'string'},
        {id: 'avg', label: 'avg', type: 'number'},
        {id: '95', label: '95%', type: 'number'},
        {id: '99', label: '99%', type: 'number'}],
      rows: []
    }
    @dirs.each do |dir|
      result=Results.new
      (1 .. 100).each do |file|
        result << self.send(test_type, "test/#{dir}/#{file}")
      end
      results[:rows] << {
        c:[
           {v: dir},
           {v: result.mean},
           {v: result.percentile(0.95)},
           {v: result.percentile(0.99)}
        ]
      }
    end
    return results
  end

  def print_json
    puts JSON.pretty_generate(@results)
  end

  def write_file filename
    resultset = Array.new
    if File.exists? 'html/results/resultset.json'
      file = File.read('html/results/resultset.json')
      resultset = JSON.parse(file)
    end

    # Update resultset file
    if not resultset.include? filename
      resultset << filename
      File.open("html/results/resultset.json","w") do |file|
        file.write(resultset.to_json)
      end
    end

    # Write results to file
    File.open("html/results/#{filename}.json","w") do |file|
      file.write(@results.to_json)
    end
  end

  def initialize dirs
    @dirs = dirs
    @results=Hash.new
    @results[:read_1] = run_test("read")
    @results[:append_1] = run_test("append")
    @results[:read_2] = run_test("read")
    @results[:append_2] = run_test("append")
  end

end


if $0 == __FILE__
  if ARGV.length != 1
    puts "Usage ./benchmark.rb <testname>"
    exit 1
  end
  dirs=["1k", "10k", "1000k", "10000k"] 
  test=Testfile.new dirs
  test.write_file ARGV[0]
end
