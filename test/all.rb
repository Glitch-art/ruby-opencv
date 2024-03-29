# Run all tests in the test folder
# Usage: `ruby test/all.rb`

require 'test/unit'

# Require all test files
tests = Dir.glob(File.join(__dir__, '**', 'test_*.rb'))
results = []

print("Starting tests\n")
print("Tests to run: #{tests.length}\n")

tests.each_with_index do |file, index|
  index += 1
  status = :in_progress
  puts "Running test #{index} of #{tests.length}"
  puts "Test file: #{file}"
  
  begin
    result = system("ruby #{file}")

    status = :success
    results << { file: file, status: status }
  rescue Exception => e
    status = :failure
    puts "Test #{index} finished, failure"
    results << { file: file, status: status, error: e.message }
  ensure
    puts "Test #{index} finished"
    puts "-----------------------------------------------------------------------------------"
  end
end

# print summary
success = results.select { |r| r[:status] == :success }.length
failure = results.select { |r| r[:status] == :failure }.length
puts "Summary"
puts "Tests run: #{results.length}"
puts "Success: #{success}"
puts "Failures: #{failure}"
puts "End of tests run"
