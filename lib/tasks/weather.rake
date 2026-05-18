namespace :weather do
  desc "Sync today + 15-day forecast for all locations from Visual Crossing"
  task sync: :environment do
    VisualCrossingSync.sync_all
    puts "Weather sync complete."
  end

  desc "Sync a specific location by name (e.g. rake weather:sync_location[\"Orange, VA\"])"
  task :sync_location, [ :name ] => :environment do |_, args|
    location = Location.find_by!(name: args[:name])
    VisualCrossingSync.sync_location(location)
    puts "Synced #{location.name}."
  end

  desc "Backfill weather from a start date (e.g. rake weather:backfill[2026-03-01])"
  task :backfill, [ :from ] => :environment do |_, args|
    from = Date.parse(args[:from])
    VisualCrossingSync.sync_all(from:, to: Date.current + 15)
    puts "Backfill complete from #{from}."
  end
end
