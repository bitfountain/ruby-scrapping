require 'sqlite3'
    
db = SQLite3::Database.open "db_tour_scraper.db"

puts "Migration started ...."

db.execute <<SQL
CREATE TABLE IF NOT EXISTS tickets_summary (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  departure_date Date,
  return_date Date,
  time_from_out VARCHAR(20),
  time_to_out VARCHAR(20),
  search_time DateTime,
  total_tickets_out INTEGER,
  total_tickets_in INTEGER
);
SQL
puts "Table tickets_summary created"

db.execute <<SQL
CREATE TABLE IF NOT EXISTS tickets_airline_companies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ticket_summary_id INTEGER,
  airline_company_name VARCHAR(100),
  ticket_lowest_price FLOAT,
  total_flights_available INTEGER,
  ticket_type VARCHAR(10),
  FOREIGN KEY(ticket_summary_id) REFERENCES tickets_summary(id)
);
SQL
puts "Table tickets_airline_companies created"

db.execute <<SQL
CREATE TABLE IF NOT EXISTS airline_flights (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ticket_airline_id INTEGER,
  flight_code VARCHAR(50),
  flight_price INTEGER,
  flight_changable_status VARCHAR(50),
  flight_ticket_type VARCHAR(100),
  FOREIGN KEY(ticket_airline_id) REFERENCES tickets_airlines(id)
);
SQL

puts "Table airline_flights created"
puts "Migration ended."
