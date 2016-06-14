require "honeybadger-api"

access_token = "xxx"

Honeybadger::Api.configure do |c|
  c.access_token = access_token
end

project_id = "1404"

report_date = Date.today - 7
report_date_epoch = report_date.to_time.to_i.to_s

# Unresolved Faults
filters = {
  :environment => "production",
  :resolved => "f",
  :ignore => "f",
  :occurred_after => report_date_epoch
}

paginator = Honeybadger::Api::Fault.paginate(project_id, filters)
while(paginator.next?)
  paginator.next
end

unresolved_fault_count = paginator.collection.count

# Resolved Faults
filters = {
  :environment => "production",
  :resolved => "t",
  :ignore => "f",
  :occurred_after => report_date_epoch
}
paginator = Honeybadger::Api::Fault.paginate(project_id, filters)

paginator = Honeybadger::Api::Fault.paginate(project_id, filters)
while(paginator.next?)
  paginator.next
end

resolved_fault_count = paginator.collection.count

# New Sightings Faults
filters = {
  :environment => "production",
  :resolved => "f",
  :ignore => "f",
  :created_after => report_date_epoch
}

paginator = Honeybadger::Api::Fault.paginate(project_id, filters)
while(paginator.next?)
  paginator.next
end
new_sighting_faults = paginator.collection

# Top noise
filters = {
  :environment => "production",
  :ignore => "f",
  :occurred_after => report_date_epoch
}

paginator = Honeybadger::Api::Fault.paginate(project_id, filters)
while(paginator.next?)
  paginator.next
end

top_noise_faults = paginator.collection.sort { |a, b| b.notices_count <=> a.notices_count }


puts "Unresolved faults: (#{unresolved_fault_count})"
puts "Resolved faults: (#{resolved_fault_count})\n\n"

puts "New Sighting Faults:"
puts "-----------------------------------------\n\n"

new_sighting_faults.each do |fault|
  puts "#{fault.klass} - #{fault.message}"
  puts "#{fault.component}##{fault.action}"
  puts "Notices (#{fault.notices_count})"
  puts "#{fault.resolved? ? "Resolved" : "Unresolved"}"
  puts "https://app.honeybadger.io/projects/#{project_id}/faults/#{fault.id}"
  puts ""
end

puts "Top Noise Generators:"
puts "-----------------------------------------\n\n"

top_noise_faults.first(5).each do |fault|
  puts "#{fault.klass} - #{fault.message}"
  puts "#{fault.component}##{fault.action}"
  puts "Notices (#{fault.notices_count})"
  puts "#{fault.resolved? ? "Resolved" : "Unresolved"}"
  puts "https://app.honeybadger.io/projects/#{project_id}/faults/#{fault.id}"
  puts ""
end



