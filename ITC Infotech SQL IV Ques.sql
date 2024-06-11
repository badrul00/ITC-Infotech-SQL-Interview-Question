CREATE TABLE city_distance
(
    distance INT,
    source VARCHAR(512),
    destination VARCHAR(512)
);

delete from city_distance;
INSERT INTO city_distance(distance, source, destination) VALUES ('100', 'New Delhi', 'Panipat');
INSERT INTO city_distance(distance, source, destination) VALUES ('200', 'Ambala', 'New Delhi');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Bangalore', 'Mysore');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Mysore', 'Bangalore');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Mumbai', 'Pune');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Pune', 'Mumbai');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Chennai', 'Bhopal');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Bhopal', 'Chennai');
INSERT INTO city_distance(distance, source, destination) VALUES ('60', 'Tirupati', 'Tirumala');
INSERT INTO city_distance(distance, source, destination) VALUES ('80', 'Tirumala', 'Tirupati');

select * from city_distance

--delete all duplicate

--1st solution
select c1.*
from city_distance c1
left join city_distance c2 on c1.source=c2.destination and c1.destination=c2.source
where c2.distance is null or c1.distance!=c2.distance or c1.source<c1.destination 

--2nd solution
with cte as (
select *
, case when source<destination then source else destination end as city1
, case when source<destination then destination else source end as city2
from city_distance 
)
,cte2 as(
select *
,COUNT(*) over(partition by city1,city2,distance) as cnt
from cte
)
select distance,source,destination
from cte2
where cnt=1 or (source<destination)

--3rd solution
with cte as (
select *
, row_number() over (order by (select null)) as rn
from city_distance
)
select c1.*
from cte c1
left join cte c2 on c1.source=c2.destination and c1.destination=c2.source
where c2.distance is null or c1.distance!=c2.distance or c1.rn<c2.rn
