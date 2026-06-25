class SeedSoybeanGrowthStages < ActiveRecord::Migration[8.1]
  def up
    now = Time.current
    GrowthStage.insert_all([
      { name: "VE",                      position: 1,  gdd_threshold: 75,   crop_type: "soybean", created_at: now, updated_at: now },
      { name: "VC",                      position: 2,  gdd_threshold: 155,  crop_type: "soybean", created_at: now, updated_at: now },
      { name: "V1",                      position: 3,  gdd_threshold: 250,  crop_type: "soybean", created_at: now, updated_at: now },
      { name: "V2",                      position: 4,  gdd_threshold: 350,  crop_type: "soybean", created_at: now, updated_at: now },
      { name: "V3",                      position: 5,  gdd_threshold: 450,  crop_type: "soybean", created_at: now, updated_at: now },
      { name: "V4",                      position: 6,  gdd_threshold: 565,  crop_type: "soybean", created_at: now, updated_at: now },
      { name: "V5",                      position: 7,  gdd_threshold: 680,  crop_type: "soybean", created_at: now, updated_at: now },
      { name: "R1 (Beginning Bloom)",    position: 8,  gdd_threshold: 820,  crop_type: "soybean", created_at: now, updated_at: now },
      { name: "R2 (Full Bloom)",         position: 9,  gdd_threshold: 950,  crop_type: "soybean", created_at: now, updated_at: now },
      { name: "R3 (Beginning Pod)",      position: 10, gdd_threshold: 1105, crop_type: "soybean", created_at: now, updated_at: now },
      { name: "R4 (Full Pod)",           position: 11, gdd_threshold: 1280, crop_type: "soybean", created_at: now, updated_at: now },
      { name: "R5 (Beginning Seed)",     position: 12, gdd_threshold: 1490, crop_type: "soybean", created_at: now, updated_at: now },
      { name: "R6 (Full Seed)",          position: 13, gdd_threshold: 1740, crop_type: "soybean", created_at: now, updated_at: now },
      { name: "R7 (Beginning Maturity)", position: 14, gdd_threshold: 2100, crop_type: "soybean", created_at: now, updated_at: now },
      { name: "R8 (Full Maturity)",      position: 15, gdd_threshold: 2350, crop_type: "soybean", created_at: now, updated_at: now },
    ])
  end

  def down
    GrowthStage.where(crop_type: "soybean").delete_all
  end
end
