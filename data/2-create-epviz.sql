
CREATE TABLE show_bookmark (
  iid TEXT PRIMARY KEY,
  favourite INTEGER,
  note TEXT
);

CREATE TABLE last_viewed (
  iid TEXT PRIMARY KEY,
  last_viewed Timestamp DATETIME
);

CREATE INDEX idx_last_viewed on last_viewed(last_viewed);

-- alter table show_bookmark add column favourite integer NOT NULL DEFAULT 0;
