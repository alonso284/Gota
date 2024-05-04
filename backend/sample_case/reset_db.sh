rm water_network.db
sqlite3 water_network.db < serial_schema.sql
sqlite3 water_network.db < sample_case/mock_data.sql

python3 sample_case/mock_data.ipynb

