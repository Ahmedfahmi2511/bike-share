/* join data in one table insert into all tables in table t1 */
/* clean data of  Cyclistic */
create view  bikeride_cleaned as
with clean_data as (
select 
    rideable_type,
   start_station_name,
   end_station_name,
   cast(started_at as date) as start_date,
   cast(ended_at as date) as end_date,
   cast(started_at as time  ) as start_time,
   cast(ended_at as time  ) as end_time,
   DATENAME(weekday,started_at) as day_of_week,
   datediff(minute,started_at,ended_at) as duration,
   member_casual

   from t1

   where start_station_name is not null 
       and end_station_name is not null 
	   and datediff(minute,started_at,ended_at)  > 0  )

	   select *
	    from clean_data

/* analysis for  Cyclistic */

 create view  bikeride_analysis as 

select member_casual,rideable_type,count(*)as count_cycletype ,max(duration) max_ride_length ,
min(duration) min_ride_length ,
AVG(duration) avg_ride_length ,  day_of_week

from bikeride_cleaned  

group by member_casual,rideable_type , day_of_week

order by avg_ride_length

	   
	   


	  

	  