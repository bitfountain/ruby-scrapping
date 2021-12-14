require 'sqlite3'
    
db = SQLite3::Database.open "db_tour_scraper.db"

db.execute <<SQL
CREATE TABLE IF NOT EXISTS tickets_summary (
  id INTEGER PRIMARY KEY,
  departure_date Date,
  return_date Date,
  total_tickets_found INTEGER
);
SQL

db.execute <<SQL
CREATE TABLE IF NOT EXISTS tickets_airlines (
  id INTEGER PRIMARY KEY,
  ticket_summary_id INTEGER,
  airline_company_name VARCHAR(100),
  ticket_lowest_price FLOAT,
  total_flights_available INTEGER,
  ticket_type VARCHAR(10),
  FOREIGN KEY(ticket_summary_id) REFERENCES tickets_summary(id)
);
SQL

db.execute <<SQL
CREATE TABLE IF NOT EXISTS airline_flights (
  id INTEGER PRIMARY KEY,
  ticket_airline_id INTEGER,
  flight_code VARCHAR(50),
  flight_price INTEGER,
  flight_name VARCHAR(100),
  flight_ticket_type VARCHAR(100),
  FOREIGN KEY(ticket_airline_id) REFERENCES tickets_airlines(id)
);
SQL
    
