select s.title,e.votes,e.title from ep e inner join show s on e.show_iid=s.iid AND e.rating=9.7 and e.votes>600 order by e.votes;
