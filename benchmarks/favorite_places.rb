require 'benchmark'

input = ("a".."z").map { |letter| [letter, letter] }.to_h
n = 50_000

class Benchmarks
  def self.favorite_places
    puts "User.first #{User.first}"
  end

  # Benchmark.bm do |benchmark|
  #   benchmark.report("Hash[]") do
  #     n.times do
  #       input.map { |key, value| [key.to_sym, value] }.to_h
  #     end
  #   end

  #   benchmark.report("{}.tap") do
  #     n.times do
  #       {}.tap do |new_hash|
  #         input.each do |key, value|
  #           new_hash[key.to_sym] = value
  #         end
  #       end
  #     end
  #   end
  # end
end
