
drop table if exists show_bookmark_new;

CREATE TABLE show_bookmark_new (
  iid TEXT PRIMARY KEY,
  favourite INTEGER NOT NULL DEFAULT 0,
  note TEXT
);

INSERT INTO show_bookmark_new (iid, favourite, note)
  SELECT iid, coalesce(favourite, 0), note FROM show_bookmark;


alter table show_bookmark rename to show_bookmark_old;
alter table show_bookmark_new rename to show_bookmark;
