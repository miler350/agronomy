class SoybeanCalendarDayStages < ActiveRecord::Migration[8.0]
  def up
    add_column :growth_stages, :days_threshold, :integer

    # Shift existing soybean R1-R8 (pos 8-15) up by 2 to make room for V6, V7
    execute <<~SQL
      UPDATE growth_stages
      SET position = position + 2
      WHERE crop_type = 'soybean' AND position >= 8
    SQL

    # Update existing VE-V5 with days_threshold, clear gdd_threshold
    {
      "VE" => 7, "VC" => 12, "V1" => 17, "V2" => 22,
      "V3" => 27, "V4" => 32, "V5" => 37
    }.each do |name, days|
      execute <<~SQL
        UPDATE growth_stages
        SET days_threshold = #{days}, gdd_threshold = NULL
        WHERE crop_type = 'soybean' AND name = '#{name}'
      SQL
    end

    # Update R1-R8 with days_threshold, clear gdd_threshold
    {
      "R1 (Beginning Bloom)" => 46, "R2 (Full Bloom)"       => 49,
      "R3 (Beginning Pod)"   => 58, "R4 (Full Pod)"         => 67,
      "R5 (Beginning Seed)"  => 77, "R6 (Full Seed)"        => 92,
      "R7 (Beginning Maturity)" => 109, "R8 (Full Maturity)" => 119
    }.each do |name, days|
      execute <<~SQL
        UPDATE growth_stages
        SET days_threshold = #{days}, gdd_threshold = NULL
        WHERE crop_type = 'soybean' AND name = #{connection.quote(name)}
      SQL
    end

    # Insert V6 (pos 8) and V7 (pos 9) for soybean
    execute <<~SQL
      INSERT INTO growth_stages (name, crop_type, position, days_threshold, gdd_threshold, created_at, updated_at)
      VALUES
        ('V6', 'soybean', 8, 40, NULL, NOW(), NOW()),
        ('V7', 'soybean', 9, 43, NULL, NOW(), NOW())
    SQL
  end

  def down
    # Reverse V6/V7 insert
    execute "DELETE FROM growth_stages WHERE crop_type = 'soybean' AND name IN ('V6', 'V7')"

    # Shift R1-R8 back down
    execute <<~SQL
      UPDATE growth_stages
      SET position = position - 2
      WHERE crop_type = 'soybean' AND position >= 10
    SQL

    # Restore gdd_threshold values for VE-V5
    {
      "VE" => 75, "VC" => 155, "V1" => 250, "V2" => 350,
      "V3" => 450, "V4" => 565, "V5" => 680
    }.each do |name, gdd|
      execute <<~SQL
        UPDATE growth_stages
        SET gdd_threshold = #{gdd}, days_threshold = NULL
        WHERE crop_type = 'soybean' AND name = '#{name}'
      SQL
    end

    # Restore gdd_threshold for R1-R8
    {
      "R1 (Beginning Bloom)" => 820, "R2 (Full Bloom)"          => 950,
      "R3 (Beginning Pod)"   => 1105, "R4 (Full Pod)"           => 1280,
      "R5 (Beginning Seed)"  => 1490, "R6 (Full Seed)"          => 1740,
      "R7 (Beginning Maturity)" => 2100, "R8 (Full Maturity)"   => 2350
    }.each do |name, gdd|
      execute <<~SQL
        UPDATE growth_stages
        SET gdd_threshold = #{gdd}, days_threshold = NULL
        WHERE crop_type = 'soybean' AND name = #{connection.quote(name)}
      SQL
    end

    remove_column :growth_stages, :days_threshold
  end
end
