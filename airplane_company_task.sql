-- creating tables
create table crew_members
(
	crew_member_id serial not null
		constraint crew_members_pkey
			primary key,
	first_name varchar,
	last_name varchar,
	date_of_birth date
)
;

create unique index crew_members_crew_member_id_uindex
	on crew_members (crew_member_id)
;

create table aircrafts
(
	aircraft_id serial not null
		constraint aircrafts_pkey
			primary key,
	identification varchar
)
;

create unique index aircrafts_aircrafts_id_uindex
	on aircrafts (aircraft_id)
;

create table crew_member_aircraft
(
	crew_member_id integer
		constraint crew_member_aircraft_crew_members_crew_member_id_fk
			references crew_members,
	aircraft_id integer
		constraint crew_member_aircraft_aircrafts_aircraft_id_fk
			references aircrafts
)
;

comment on table crew_member_aircraft is 'Table linking crew member with aircrafts it can operate'
;
-- populating tables
INSERT INTO public.crew_members (first_name, last_name, date_of_birth) VALUES ('Aaron', 'MacMahon', '1912-04-25');
INSERT INTO public.crew_members (first_name, last_name, date_of_birth) VALUES ('Chelsea', 'Moore', '1950-05-05');
INSERT INTO public.crew_members (first_name, last_name, date_of_birth) VALUES ('Jack', 'Keane', '1980-06-23');
INSERT INTO public.crew_members (first_name, last_name, date_of_birth) VALUES ('Philip', 'Healy', '1991-01-01');
INSERT INTO public.crew_members (first_name, last_name, date_of_birth) VALUES ('Aleksandra', 'Burns', '2000-05-07');

INSERT INTO public.aircrafts (identification) VALUES ('U2');
INSERT INTO public.aircrafts (identification) VALUES ('Tu-142');
INSERT INTO public.aircrafts (identification) VALUES ('Tu-22');
INSERT INTO public.aircrafts (identification) VALUES ('F-16');
INSERT INTO public.aircrafts (identification) VALUES ('F-22');

INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (1, 1);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (1, 2);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (1, 3);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (1, 4);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (1, 5);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (2, 1);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (2, 2);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (2, 3);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (2, 4);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (3, 1);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (3, 2);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (3, 3);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (4, 1);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (4, 2);
INSERT INTO public.crew_member_aircraft (crew_member_id, aircraft_id) VALUES (5, 1);

-- task queries

-- Find name of the oldest crew member
SELECT
    first_name, last_name, age(date_of_birth)
FROM
    crew_members
ORDER BY
    date_of_birth ASC
LIMIT 1;

-- Find name of the n-th crew member (second oldest, fifth oldest and so on)
SET SESSION vars.nth = '1';
SELECT
	first_name, last_name, age(date_of_birth)
FROM
	crew_members
ORDER BY
	date_of_birth ASC
LIMIT 1
OFFSET current_setting('vars.nth')::int-1;

-- Find name of the most experienced crew member - that one who knows most aircrafts
SELECT
    cm.first_name, cm.last_name, COUNT(cma.*) AS skills
FROM crew_members cm
INNER JOIN crew_member_aircraft cma ON cm.crew_member_id = cma.crew_member_id
GROUP BY
    cm.crew_member_id
ORDER BY
    COUNT(cma.*) DESC
LIMIT 1;

-- Find name of the least experienced crew member - that one who knows least aircrafts (counting from zero)
SELECT
    cm.first_name, cm.last_name, COUNT(cma.*) AS skills
FROM crew_members cm
LEFT JOIN crew_member_aircraft cma ON cm.crew_member_id = cma.crew_member_id
GROUP BY
	cm.crew_member_id
ORDER BY
    COUNT(cma.*) ASC
LIMIT 1;