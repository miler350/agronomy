namespace :import do
  desc "Replace all growth stages with updated thresholds from corngddthresholds.xlsx"
  task growth_stages: :environment do
    stages = [
      { position:  1, name: "Pre-VE",  gdd_threshold:    0, description: "Planting through emergence" },
      { position:  2, name: "VE",      gdd_threshold:   90, description: "Emergence" },
      { position:  3, name: "V1",      gdd_threshold:  174, description: "First leaf" },
      { position:  4, name: "V2",      gdd_threshold:  258, description: "Second leaf" },
      { position:  5, name: "V3",      gdd_threshold:  342, description: "Third leaf" },
      { position:  6, name: "V4",      gdd_threshold:  426, description: "Fourth leaf" },
      { position:  7, name: "V5",      gdd_threshold:  510, description: "Fifth leaf" },
      { position:  8, name: "V6",      gdd_threshold:  594, description: "Sixth leaf" },
      { position:  9, name: "V7",      gdd_threshold:  678, description: "Seventh leaf" },
      { position: 10, name: "V8",      gdd_threshold:  762, description: "Eighth leaf" },
      { position: 11, name: "V9",      gdd_threshold:  846, description: "Ninth leaf" },
      { position: 12, name: "V10",     gdd_threshold:  930, description: "Tenth leaf" },
      { position: 13, name: "V11",     gdd_threshold:  986, description: "Eleventh leaf" },
      { position: 14, name: "V12",     gdd_threshold: 1042, description: "Twelfth leaf" },
      { position: 15, name: "V13",     gdd_threshold: 1098, description: "Thirteenth leaf" },
      { position: 16, name: "V14",     gdd_threshold: 1154, description: "Fourteenth leaf" },
      { position: 17, name: "V15",     gdd_threshold: 1210, description: "Fifteenth leaf" },
      { position: 18, name: "V16",     gdd_threshold: 1266, description: "Sixteenth leaf" },
      { position: 19, name: "V17",     gdd_threshold: 1322, description: "Seventeenth leaf" },
      { position: 20, name: "V18",     gdd_threshold: 1378, description: "Eighteenth leaf" },
      { position: 21, name: "VT",      gdd_threshold: 1434, description: "Tasseling" },
      { position: 22, name: "R1",      gdd_threshold: 1490, description: "Silking" },
      { position: 23, name: "R2",      gdd_threshold: 1710, description: "Blister" },
      { position: 24, name: "R3",      gdd_threshold: 1890, description: "Milk" },
      { position: 25, name: "R4",      gdd_threshold: 2020, description: "Dough" },
      { position: 26, name: "R5",      gdd_threshold: 2140, description: "Dent" },
      { position: 27, name: "R6",      gdd_threshold: 2715, description: "Black layer (maturity)" },
    ]

    puts "Replacing #{GrowthStage.count} existing stages..."
    GrowthStage.delete_all
    GrowthStage.insert_all!(stages)
    puts "Inserted #{GrowthStage.count} growth stages."
  end

  desc "Update field lat/lng centroids from CS_CroplandFields_2026 shapefile"
  task field_centroids: :environment do
    centroids = {
      "AF1"  => [38.314537, -78.298759],
      "DA2"  => [38.250056, -78.355833],
      "DF12" => [38.417111, -78.247518],
      "DF13" => [38.415927, -78.250108],
      "DF15" => [38.417493, -78.252951],
      "DF19" => [38.414791, -78.242482],
      "DF20" => [38.415633, -78.238712],
      "DF21" => [38.418489, -78.241605],
      "DF23" => [38.422012, -78.241902],
      "DF24" => [38.422293, -78.245592],
      "DF26" => [38.426520, -78.241876],
      "DF27" => [38.423671, -78.240153],
      "DF33" => [38.420197, -78.234225],
      "DP1"  => [38.248331, -78.349887],
      "DP2"  => [38.247688, -78.345811],
      "DP3"  => [38.242959, -78.349100],
      "DP5"  => [38.245219, -78.348711],
      "DP6"  => [38.245373, -78.344475],
      "DP7"  => [38.244997, -78.355620],
      "E11"  => [38.295070, -78.279999],
      "E5"   => [38.296012, -78.283984],
      "E6"   => [38.302547, -78.279088],
      "E8"   => [38.300154, -78.276035],
      "H10"  => [38.315175, -78.307383],
      "H11"  => [38.312879, -78.306646],
      "H14"  => [38.300002, -78.314003],
      "H15"  => [38.302520, -78.313462],
      "H16"  => [38.304322, -78.305845],
      "H17"  => [38.305292, -78.303302],
      "H18"  => [38.302140, -78.303751],
      "H19"  => [38.304799, -78.309333],
      "H20"  => [38.302837, -78.301295],
      "H22"  => [38.300481, -78.297214],
      "H24"  => [38.292397, -78.295587],
      "H25"  => [38.293983, -78.286667],
      "H26"  => [38.309548, -78.307788],
      "H27"  => [38.293516, -78.283854],
      "H40"  => [38.294894, -78.290197],
      "J1"   => [38.429922, -78.237885],
      "JS2"  => [38.284057, -78.254115],
      "JS3"  => [38.279897, -78.253997],
      "JS6"  => [38.280000, -78.249671],
      "Jake" => [38.314956, -78.286574],
      "M2"   => [38.285495, -78.261302],
      "S10"  => [38.305705, -78.280363],
      "S6"   => [38.303633, -78.280747],
      "S9"   => [38.307776, -78.278030],
      "SM1"  => [38.316998, -78.304058],
      "SM2"  => [38.314800, -78.302037],
      "ST17" => [38.273694, -78.353010],
      "ST3"  => [38.270558, -78.355432],
    }

    updated = 0
    centroids.each do |name, (lat, lng)|
      rows = Field.where(name:).update_all(latitude: lat, longitude: lng)
      updated += rows
    end
    puts "Updated lat/lng for #{updated} fields."
  end
end
