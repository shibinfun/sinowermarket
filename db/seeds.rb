
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🌱 Seeding database with test data..."

# Clean existing data
puts "Cleaning existing data..."
# Disable foreign key checks for SQLite to avoid constraint issues
if ActiveRecord::Base.connection.adapter_name == 'SQLite'
  ActiveRecord::Base.connection.execute('PRAGMA foreign_keys = OFF')
end
Sku.delete_all
Category.delete_all
User.delete_all if defined?(User) && User.table_exists?
if ActiveRecord::Base.connection.adapter_name == 'SQLite'
  ActiveRecord::Base.connection.execute('PRAGMA foreign_keys = ON')
end

# Define 18 primary categories with their subcategories and SKUs
categories_data = [
  {
    name: "Business Type",
    children: [
      { name: "Restaurant", skus: [
        { name: "Commercial Range 6 Burner", price: 2499.00, stock: 50, sku_code: "BT-RS-001" },
        { name: "Stainless Steel Work Table 180cm", price: 399.00, stock: 200, sku_code: "BT-RS-002" },
        { name: "Undercounter Refrigerator", price: 899.00, stock: 80, sku_code: "BT-RS-003" }
      ]},
      { name: "Bakery", skus: [
        { name: "Deck Oven 2-Tray Electric", price: 3299.00, stock: 30, sku_code: "BT-BK-001" },
        { name: "Planetary Mixer 20L", price: 1299.00, stock: 60, sku_code: "BT-BK-002" },
        { name: "Proofing Cabinet Single Door", price: 1599.00, stock: 40, sku_code: "BT-BK-003" }
      ]},
      { name: "Café", skus: [
        { name: "Espresso Machine 2 Group", price: 4599.00, stock: 25, sku_code: "BT-CF-001" },
        { name: "Coffee Grinder Commercial", price: 699.00, stock: 100, sku_code: "BT-CF-002" },
        { name: "Blended Ice Drink Machine", price: 399.00, stock: 80, sku_code: "BT-CF-003" }
      ]},
      { name: "Butchery", skus: [
        { name: "Meat Band Saw 350mm Blade", price: 1899.00, stock: 30, sku_code: "BT-BT-001" },
        { name: "Meat Mincer No.32", price: 799.00, stock: 60, sku_code: "BT-BT-002" },
        { name: "Vacuum Packaging Machine", price: 599.00, stock: 80, sku_code: "BT-BT-003" }
      ]}
    ]
  },
  {
    name: "Cooking Appliances",
    children: [
      { name: "Ranges & Cooktops", skus: [
        { name: "Gas Range 4 Burner with Oven", price: 1899.00, stock: 40, sku_code: "CA-RC-001" },
        { name: "Induction Cooktop Double Zone", price: 699.00, stock: 120, sku_code: "CA-RC-002" },
        { name: "Pasta Cooker 6 Basket Electric", price: 2199.00, stock: 25, sku_code: "CA-RC-003" }
      ]},
      { name: "Fryers", skus: [
        { name: "Deep Fryer Double Tank 20L", price: 899.00, stock: 80, sku_code: "CA-FR-001" },
        { name: "Pressure Fryer 13L", price: 1299.00, stock: 40, sku_code: "CA-FR-002" },
        { name: "Countertop Fryer Single 10L", price: 449.00, stock: 100, sku_code: "CA-FR-003" }
      ]},
      { name: "Steamers", skus: [
        { name: "Combi Steamer 10 GN1/1", price: 5999.00, stock: 15, sku_code: "CA-ST-001" },
        { name: "Electric Steamer 3 Tier", price: 1299.00, stock: 50, sku_code: "CA-ST-002" },
        { name: "Pressure Steamer Gas", price: 1899.00, stock: 30, sku_code: "CA-ST-003" }
      ]}
    ]
  },
  {
    name: "Refrigeration",
    children: [
      { name: "Upright Refrigerators", skus: [
        { name: "2 Door Upright Fridge GN1100", price: 1499.00, stock: 60, sku_code: "RF-UR-001" },
        { name: "4 Door Upright Fridge/Freezer", price: 2199.00, stock: 40, sku_code: "RF-UR-002" },
        { name: "Single Door Fridge GN600", price: 899.00, stock: 80, sku_code: "RF-UR-003" }
      ]},
      { name: "Blast Chillers", skus: [
        { name: "Blast Chiller 5 GN1/1", price: 3999.00, stock: 20, sku_code: "RF-BC-001" },
        { name: "Shock Freezer 3 GN1/1", price: 3499.00, stock: 25, sku_code: "RF-BC-002" }
      ]},
      { name: "Prep Counters", skus: [
        { name: "Pizza Prep Counter 150cm", price: 1299.00, stock: 50, sku_code: "RF-PC-001" },
        { name: "Saladette Counter 3 Doors", price: 1599.00, stock: 35, sku_code: "RF-PC-002" },
        { name: "Refrigerated Workbench 180cm", price: 1199.00, stock: 45, sku_code: "RF-PC-003" }
      ]}
    ]
  },
  {
    name: "Dough & Flour",
    children: [
      { name: "Mixers", skus: [
        { name: "Spiral Mixer 25kg Bowl", price: 1899.00, stock: 30, sku_code: "DF-MX-001" },
        { name: "Planetary Mixer 30L", price: 1499.00, stock: 40, sku_code: "DF-MX-002" },
        { name: "Dough Sheeter 52cm", price: 2299.00, stock: 25, sku_code: "DF-MX-003" }
      ]},
      { name: "Dividers & Rounders", skus: [
        { name: "Dough Divider 36 Portions", price: 1699.00, stock: 20, sku_code: "DF-DR-001" },
        { name: "Dough Rounder Automatic", price: 1299.00, stock: 25, sku_code: "DF-DR-002" }
      ]},
      { name: "Flour Storage", skus: [
        { name: "Flour Bin 50kg Stainless Steel", price: 299.00, stock: 100, sku_code: "DF-FS-001" },
        { name: "Flour Sifter Electric 30kg/h", price: 499.00, stock: 60, sku_code: "DF-FS-002" }
      ]}
    ]
  },
  {
    name: "Stainless Steel Furniture",
    children: [
      { name: "Work Tables", skus: [
        { name: "Work Table 180x70cm with Splashback", price: 349.00, stock: 150, sku_code: "SF-WT-001" },
        { name: "Wall Shelf 120x30cm SS", price: 129.00, stock: 200, sku_code: "SF-WT-002" },
        { name: "Under-shelf 150x40cm SS", price: 149.00, stock: 180, sku_code: "SF-WT-003" }
      ]},
      { name: "Cabinets & Cupboards", skus: [
        { name: "Wall Cabinet 2 Doors 120cm", price: 449.00, stock: 80, sku_code: "SF-CC-001" },
        { name: "Base Cabinet Sliding Doors 120cm", price: 549.00, stock: 60, sku_code: "SF-CC-002" }
      ]},
      { name: "Transport Trolleys", skus: [
        { name: "GN Trolley 20x GN1/1", price: 299.00, stock: 100, sku_code: "SF-TT-001" },
        { name: "Plate Trolley 40 Plates Melamine", price: 349.00, stock: 80, sku_code: "SF-TT-002" }
      ]}
    ]
  },
  {
    name: "Keep Warm",
    children: [
      { name: "Hot Cupboards", skus: [
        { name: "Hot Holding Cabinet 3 Doors", price: 1299.00, stock: 30, sku_code: "KW-HC-001" },
        { name: "Heated Proofing Cabinet", price: 999.00, stock: 40, sku_code: "KW-HC-002" }
      ]},
      { name: "Heat Lamps", skus: [
        { name: "Pass-through Heat Lamp 2 Quartz", price: 349.00, stock: 80, sku_code: "KW-HL-001" },
        { name: "Freestanding Infrared Lamp", price: 249.00, stock: 100, sku_code: "KW-HL-002" }
      ]},
      { name: "Bain Maries", skus: [
        { name: "Bain Marie 4 Pan Dry Heat", price: 599.00, stock: 60, sku_code: "KW-BM-001" },
        { name: "Bain Marie 6 Pan Wet Heat", price: 799.00, stock: 45, sku_code: "KW-BM-002" },
        { name: "Countertop Bain Marie 3 Pan", price: 449.00, stock: 70, sku_code: "KW-BM-003" }
      ]}
    ]
  },
  {
    name: "Kitchenware",
    children: [
      { name: "Pots & Pans", skus: [
        { name: "Stockpot 40L Aluminum", price: 89.00, stock: 300, sku_code: "KW-PP-001" },
        { name: "Frying Pan 32cm Stainless", price: 69.00, stock: 400, sku_code: "KW-PP-002" },
        { name: "Saucepan 8L Induction Base", price: 59.00, stock: 350, sku_code: "KW-PP-003" }
      ]},
      { name: "Utensils", skus: [
        { name: "Chef Knife 25cm German Steel", price: 79.00, stock: 500, sku_code: "KW-UT-001" },
        { name: "Ladle 300mm Stainless", price: 12.00, stock: 1000, sku_code: "KW-UT-002" },
        { name: "Tongs 30cm Silicone Tip", price: 9.90, stock: 800, sku_code: "KW-UT-003" }
      ]},
      { name: "GN Containers", skus: [
        { name: "GN Container 1/1 100mm SS", price: 19.90, stock: 600, sku_code: "KW-GN-001" },
        { name: "GN Lid Polycarbonate 1/1", price: 8.90, stock: 800, sku_code: "KW-GN-002" },
        { name: "GN Container 1/3 65mm PC", price: 7.90, stock: 1000, sku_code: "KW-GN-003" }
      ]}
    ]
  },
  {
    name: "Ovens",
    children: [
      { name: "Convection Ovens", skus: [
        { name: "Electric Convection Oven 4 Tray", price: 1899.00, stock: 30, sku_code: "OV-CN-001" },
        { name: "Gas Convection Oven 5 Tray", price: 2199.00, stock: 25, sku_code: "OV-CN-002" },
        { name: "Mini Convection Oven 1/1 GN", price: 999.00, stock: 50, sku_code: "OV-CN-003" }
      ]},
      { name: "Deck Ovens", skus: [
        { name: "Single Deck Oven 2 Trays", price: 1599.00, stock: 35, sku_code: "OV-DK-001" },
        { name: "Double Deck Oven 4 Trays", price: 2999.00, stock: 20, sku_code: "OV-DK-002" }
      ]},
      { name: "Pizza Ovens", skus: [
        { name: "Stone Deck Pizza Oven Single", price: 1299.00, stock: 40, sku_code: "OV-PZ-001" },
        { name: "Conveyor Pizza Oven Electric", price: 3499.00, stock: 15, sku_code: "OV-PZ-002" },
        { name: "Wood Fired Pizza Oven 90cm", price: 2499.00, stock: 20, sku_code: "OV-PZ-003" }
      ]}
    ]
  },
  {
    name: "Retail Refrigeration",
    children: [
      { name: "Display Cabinets", skus: [
        { name: "Glass Door Display Fridge 900L", price: 1899.00, stock: 30, sku_code: "RR-DC-001" },
        { name: "Open Display Chiller 1500mm", price: 2499.00, stock: 20, sku_code: "RR-DC-002" },
        { name: "Pastry Display Case 3 Shelf", price: 1599.00, stock: 25, sku_code: "RR-DC-003" }
      ]},
      { name: "Ice Cream Freezers", skus: [
        { name: "Chest Freezer Glass Top 500L", price: 799.00, stock: 50, sku_code: "RR-IC-001" },
        { name: "Ice Cream Display -18°C 7 Pans", price: 1299.00, stock: 30, sku_code: "RR-IC-002" }
      ]},
      { name: "Bottle Coolers", skus: [
        { name: "Back Bar Cooler 2 Glass Doors", price: 999.00, stock: 40, sku_code: "RR-BC-001" },
        { name: "Wine Cooler 50 Bottles", price: 699.00, stock: 60, sku_code: "RR-BC-002" }
      ]}
    ]
  },
  {
    name: "Meat Processing",
    children: [
      { name: "Saws & Cutters", skus: [
        { name: "Bone Saw 2000mm Blade", price: 2499.00, stock: 20, sku_code: "MP-SC-001" },
        { name: "Meat Cutter Electric 1HP", price: 899.00, stock: 40, sku_code: "MP-SC-002" }
      ]},
      { name: "Grinders & Mincers", skus: [
        { name: "Commercial Mincer No.52", price: 1299.00, stock: 30, sku_code: "MP-GM-001" },
        { name: "Bowl Cutter 20L", price: 2999.00, stock: 15, sku_code: "MP-GM-002" }
      ]},
      { name: "Slicers", skus: [
        { name: "Deli Slicer 300mm Blade", price: 699.00, stock: 50, sku_code: "MP-SL-001" },
        { name: "Gravity Feed Slicer 250mm", price: 449.00, stock: 70, sku_code: "MP-SL-002" },
        { name: "Automatic Slicer 350mm", price: 999.00, stock: 35, sku_code: "MP-SL-003" }
      ]}
    ]
  },
  {
    name: "Washing & Cleaning",
    children: [
      { name: "Dishwashers", skus: [
        { name: "Undercounter Dishwasher", price: 1499.00, stock: 30, sku_code: "WC-DW-001" },
        { name: "Hood Type Dishwasher 40 Racks/h", price: 3999.00, stock: 15, sku_code: "WC-DW-002" },
        { name: "Glass Washer Countertop", price: 899.00, stock: 50, sku_code: "WC-DW-003" }
      ]},
      { name: "Pot Washers", skus: [
        { name: "Industrial Pot Sink 2 Bowl", price: 499.00, stock: 60, sku_code: "WC-PW-001" },
        { name: "High Pressure Pre-Rinse Unit", price: 349.00, stock: 80, sku_code: "WC-PW-002" }
      ]},
      { name: "Cleaning Supplies", skus: [
        { name: "Floor Squeegee 50cm Stainless", price: 29.90, stock: 300, sku_code: "WC-CS-001" },
        { name: "Janitor Cart with Wringer 36L", price: 129.00, stock: 100, sku_code: "WC-CS-002" },
        { name: "Hand Soap Dispenser Wall Mount", price: 39.00, stock: 200, sku_code: "WC-CS-003" }
      ]}
    ]
  },
  {
    name: "Textiles",
    children: [
      { name: "Chef Wear", skus: [
        { name: "Chef Jacket Long Sleeve White L", price: 39.00, stock: 500, sku_code: "TX-CW-001" },
        { name: "Chef Pants Black Checkered M", price: 29.00, stock: 600, sku_code: "TX-CW-002" },
        { name: "Chef Hat Tall Pleated White", price: 12.00, stock: 800, sku_code: "TX-CW-003" }
      ]},
      { name: "Aprons", skus: [
        { name: "Bib Apron Canvas Navy Blue", price: 19.90, stock: 700, sku_code: "TX-AP-001" },
        { name: "Waist Apron 3 Pocket Black", price: 14.90, stock: 800, sku_code: "TX-AP-002" }
      ]},
      { name: "Kitchen Linen", skus: [
        { name: "Tea Towel 50x70cm Pack of 10", price: 24.90, stock: 400, sku_code: "TX-KL-001" },
        { name: "Oven Mitt Silicone Red Pair", price: 15.90, stock: 500, sku_code: "TX-KL-002" },
        { name: "Bar Mop Towel 40x60cm Dozen", price: 19.90, stock: 300, sku_code: "TX-KL-003" }
      ]}
    ]
  },
  {
    name: "Set Table",
    children: [
      { name: "Plates & Dishes", skus: [
        { name: "Dinner Plate 27cm Porcelain", price: 8.90, stock: 1000, sku_code: "ST-PD-001" },
        { name: "Side Plate 21cm White Stackable", price: 5.90, stock: 1200, sku_code: "ST-PD-002" },
        { name: "Pasta Bowl 24cm Rimmed", price: 9.90, stock: 800, sku_code: "ST-PD-003" }
      ]},
      { name: "Cutlery", skus: [
        { name: "Dinner Fork 18/10 Stainless", price: 3.90, stock: 2000, sku_code: "ST-CT-001" },
        { name: "Table Spoon 18/0 Mirror Finish", price: 3.50, stock: 2000, sku_code: "ST-CT-002" },
        { name: "Steak Knife Serrated Edge", price: 4.90, stock: 1500, sku_code: "ST-CT-003" }
      ]},
      { name: "Glassware", skus: [
        { name: "Water Goblet 350cl Tempered", price: 4.90, stock: 1500, sku_code: "ST-GL-001" },
        { name: "Wine Glass 25cl Red Crystal", price: 7.90, stock: 1000, sku_code: "ST-GL-002" },
        { name: "Beer Mug 50cl Thick Glass", price: 5.90, stock: 1200, sku_code: "ST-GL-003" }
      ]}
    ]
  },
  {
    name: "Grills",
    children: [
      { name: "Charbroilers", skus: [
        { name: "Gas Charbroiler 60cm Lava Rock", price: 1299.00, stock: 30, sku_code: "GR-CB-001" },
        { name: "Countertop Charbroiler 30cm", price: 699.00, stock: 50, sku_code: "GR-CB-002" }
      ]},
      { name: "Griddles", skus: [
        { name: "Flat Top Griddle 90cm Gas", price: 1599.00, stock: 25, sku_code: "GR-GD-001" },
        { name: "Ribbed Griddle 60cm Electric", price: 999.00, stock: 35, sku_code: "GR-GD-002" },
        { name: "Split Griddle Flat/Ribbed 60cm", price: 1199.00, stock: 30, sku_code: "GR-GD-003" }
      ]},
      { name: "Contact Grills", skus: [
        { name: "Panini Press Double Grooved", price: 449.00, stock: 60, sku_code: "GR-CG-001" },
        { name: "Smooth Contact Grill Large", price: 549.00, stock: 45, sku_code: "GR-CG-002" }
      ]}
    ]
  },
  {
    name: "Café, Ice Cream & Waffles",
    children: [
      { name: "Ice Cream Machines", skus: [
        { name: "Soft Serve Machine 2 Flavor", price: 3999.00, stock: 15, sku_code: "CI-IM-001" },
        { name: "Batch Freezer Gelato 5L", price: 5999.00, stock: 10, sku_code: "CI-IM-002" },
        { name: "Ice Cream Dipping Cabinet 12 Pan", price: 2499.00, stock: 20, sku_code: "CI-IM-003" }
      ]},
      { name: "Waffle Makers", skus: [
        { name: "Belgian Waffle Maker Double", price: 399.00, stock: 70, sku_code: "CI-WF-001" },
        { name: "Bubble Waffle Maker Electric", price: 299.00, stock: 80, sku_code: "CI-WF-002" }
      ]},
      { name: "Crepe & Pancake", skus: [
        { name: "Crepe Maker 40cm Cast Iron", price: 349.00, stock: 60, sku_code: "CI-CP-001" },
        { name: "Pancake Dispenser Stack 50 Plates", price: 199.00, stock: 40, sku_code: "CI-CP-002" }
      ]}
    ]
  },
  {
    name: "Food Processing",
    children: [
      { name: "Blenders & Mixers", skus: [
        { name: "Immersion Blender 400mm", price: 299.00, stock: 80, sku_code: "FP-BM-001" },
        { name: "Food Processor 5L Continuous", price: 899.00, stock: 40, sku_code: "FP-BM-002" },
        { name: "Stick Blender Variable Speed", price: 199.00, stock: 100, sku_code: "FP-BM-003" }
      ]},
      { name: "Slicers & Peelers", skus: [
        { name: "Vegetable Peeler Electric", price: 449.00, stock: 60, sku_code: "FP-SP-001" },
        { name: "Tomato Slicer Manual 12 Blades", price: 129.00, stock: 100, sku_code: "FP-SP-002" }
      ]},
      { name: "Juicers", skus: [
        { name: "Citrus Juicer Automatic Heavy Duty", price: 599.00, stock: 50, sku_code: "FP-JC-001" },
        { name: "Cold Press Juicer Commercial", price: 1299.00, stock: 30, sku_code: "FP-JC-002" },
        { name: "Centrifugal Juicer 1.5L", price: 399.00, stock: 70, sku_code: "FP-JC-003" }
      ]}
    ]
  },
  {
    name: "Ventilation",
    children: [
      { name: "Extraction Hoods", skus: [
        { name: "Wall Canopy Hood 200cm SS", price: 899.00, stock: 30, sku_code: "VT-EH-001" },
        { name: "Island Hood 300cm SS", price: 1599.00, stock: 15, sku_code: "VT-EH-002" },
        { name: "Compact Hood 100cm Wall Mount", price: 599.00, stock: 50, sku_code: "VT-EH-003" }
      ]},
      { name: "Grease Filters", skus: [
        { name: "Baffle Filter 500x500mm SS", price: 39.00, stock: 200, sku_code: "VT-GF-001" },
        { name: "Mesh Filter 600x300mm Aluminum", price: 25.00, stock: 300, sku_code: "VT-GF-002" }
      ]},
      { name: "Exhaust Fans", skus: [
        { name: "Inline Duct Fan 300mm", price: 349.00, stock: 60, sku_code: "VT-EF-001" },
        { name: "Roof Exhaust Fan 400mm", price: 599.00, stock: 40, sku_code: "VT-EF-002" },
        { name: "Make-Up Air Unit 2000m³/h", price: 1299.00, stock: 20, sku_code: "VT-EF-003" }
      ]}
    ]
  },
  {
    name: "Chairs & Tables",
    children: [
      { name: "Dining Chairs", skus: [
        { name: "Stackable Chair Polypropylene Black", price: 49.00, stock: 500, sku_code: "CT-DC-001" },
        { name: "Wooden Bistro Chair Beech", price: 89.00, stock: 300, sku_code: "CT-DC-002" },
        { name: "Bar Stool Chrome Adjustable", price: 79.00, stock: 200, sku_code: "CT-DC-003" }
      ]},
      { name: "Dining Tables", skus: [
        { name: "Square Table 80x80cm Laminate", price: 149.00, stock: 150, sku_code: "CT-DT-001" },
        { name: "Round Table 90cm Diameter", price: 179.00, stock: 120, sku_code: "CT-DT-002" },
        { name: "Rectangular Table 160x80cm", price: 229.00, stock: 100, sku_code: "CT-DT-003" }
      ]},
      { name: "Outdoor Furniture", skus: [
        { name: "Folding Table 180cm Plastic", price: 89.00, stock: 200, sku_code: "CT-OF-001" },
        { name: "Rattan Garden Chair Set 4pc", price: 299.00, stock: 80, sku_code: "CT-OF-002" }
      ]}
    ]
  }
]

puts "Creating categories and SKUs..."
total_categories = 0
total_skus = 0

categories_data.each_with_index do |cat_data, index|
  # Create primary category
  primary = Category.find_or_create_by!(name: cat_data[:name]) do |c|
    c.position = index + 1
  end
  total_categories += 1
  puts "  ✓ Created primary category: #{primary.name}"

  # Create subcategories and SKUs
  cat_data[:children].each do |child_data|
    child = Category.find_or_create_by!(name: child_data[:name], parent: primary) do |c|
      c.position = cat_data[:children].index(child_data) + 1
    end
    total_categories += 1
    puts "    ↳ Subcategory: #{child.name}"

    # Create SKUs for this subcategory
    child_data[:skus].each do |sku_data|
      sku = Sku.find_or_create_by!(name: sku_data[:name], category: child) do |s|
        s.original_price = sku_data[:price]
        s.current_price = sku_data[:price]
        s.description = "#{sku_data[:name]} - Professional grade commercial kitchen equipment."
      end
j
      # Add placeholder image if none attached
      if !sku.images.attached?
        begin
          sku.images.attach(
            io: File.open(Rails.root.join('test/fixtures/files/product_placeholder.png')),
            filename: 'product_placeholder.png',
            content_type: 'image/png'
          )
        rescue => e
          puts "      ⚠️ Could not attach image to #{sku.name}: #{e.message}"
        end
      end

      total_skus += 1
    end
  end
end

puts "\n✅ Seeding complete!"
puts "📊 Summary:"
puts "   Primary categories: 18"
puts "   Total categories: #{Category.count}"
puts "   Total SKUs: #{total_skus}"
puts "   Total products in DB: #{Sku.count}"

# Create admin user
puts "\nCreating admin user..."
admin_user = User.find_or_initialize_by(email: 'admin@gmail.com')
if admin_user.new_record?
  admin_user.password = 'password'
  admin_user.password_confirmation = 'password'
  admin_user.admin = true
  if admin_user.save
    puts "✓ Admin user created: #{admin_user.email} (Password: password)"
  else
    puts "✗ Failed to create admin user: #{admin_user.errors.full_messages.join(', ')}"
  end
else
  puts "ℹ Admin user already exists: #{admin_user.email}"
end
