select
    dateadd(day, seq4(), '2000-01-01')::date as day
from
    table(generator(rowcount => 365 * 25))
