 
-- КРОК 1. Підготовка користувачів (users)
with users_parsed as (
     select u.user_id,
            u.signup_datetime,
            u.promo_signup_flag,
        /* signup_ts - очищена дата реєстрації */
      case 
         when trim(u.signup_datetime) is null 
         or trim(u.signup_datetime) = '' 
         then null
         else 
           to_date(
           split_part(trim(u.signup_datetime), ' ', 1),
       case 
          when split_part(trim(u.signup_datetime), ' ', 1) ~ '^\d{1,2}[-./]\d{1,2}[-./]\d{4}$' 
          then 'dd-mm-yyyy'
          when split_part(trim(u.signup_datetime), ' ', 1) ~ '^\d{1,2}[-./]\d{1,2}[-./]\d{2}$'  
          then 'dd-mm-yy'
          when split_part(trim(u.signup_datetime), ' ', 1) ~ '^\d{4}[-./]\d{1,2}[-./]\d{1,2}$' 
          then 'yyyy-mm-dd'
       else null
       end)
     end as signup_ts
    from cohort_users_raw u),
-- КРОК 2. Підготовка подій (events)
events_parsed as (
 select e.user_id,
        e.event_type,       
        /* event_ts - очищена дата події */
   case 
      when trim(e.event_datetime) is null 
      or trim(e.event_datetime) = '' 
      then null
       else 
        to_date(
                    split_part(trim(e.event_datetime), ' ', 1),
                    case 
                        when split_part(trim(e.event_datetime), ' ', 1) ~ '^\d{1,2}[-./]\d{1,2}[-./]\d{4}$' 
                            then 'dd-mm-yyyy'
                        when split_part(trim(e.event_datetime), ' ', 1) ~ '^\d{1,2}[-./]\d{1,2}[-./]\d{2}$'  
                            then 'dd-mm-yy'
                        when split_part(trim(e.event_datetime), ' ', 1) ~ '^\d{4}[-./]\d{1,2}[-./]\d{1,2}$' 
                            then 'yyyy-mm-dd'
                        else null
                    end
                )
        end as event_ts
    from cohort_events_raw e
),
-- КРОК 3. Об’єднання + розрахунок когорт
user_activity as (
    select
        u.user_id,
        u.promo_signup_flag,       
        /* cohort_month — місяць реєстрації */
        to_char(u.signup_ts, 'yyyy-mm') as cohort_month,        
        /* activity_month — місяць події */
        to_char(e.event_ts, 'yyyy-mm') as activity_month,        
        /* month_offset — стаж у місяцях */
        (extract(year from age(e.event_ts, u.signup_ts)) * 12 
         + extract(month from age(e.event_ts, u.signup_ts))) as month_offset       
    from users_parsed u
    join events_parsed e 
        on u.user_id = e.user_id   
    where u.signup_ts is not null
      and e.event_ts is not null
      and e.event_type is not null
      and e.event_type <> 'test_event'
)
-- КРОК 4. Фінальна агрегація
select
    promo_signup_flag,
    cohort_month,
    month_offset,
    count(distinct user_id) as users_total
from user_activity
where 
    activity_month between '2025-01' and '2025-06'
group by 
    promo_signup_flag, 
    cohort_month, 
    month_offset
order by 
    promo_signup_flag, 
    cohort_month, 
    month_offset;