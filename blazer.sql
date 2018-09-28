SELECT
  (
    DATE_TRUNC(
      'day',
      (created_at :: timestamptz - INTERVAL '0 second') AT TIME ZONE 'Etc/UTC'
    ) + INTERVAL '0 second'
  ) AT TIME ZONE 'Etc/UTC' AS date_trunc_day_created_at_timestampz_interval_0_second_at_time,
  COUNT(*) AS count_all
FROM
  "users"
WHERE
  (created_at IS NOT NULL)
GROUP BY(
    DATE_TRUNC(
      'day',
      (created_at :: timestamptz - INTERVAL '0 second') AT TIME ZONE 'Etc/UTC'
    ) + INTERVAL '0 second'
  ) AT TIME ZONE 'Etc/UTC'


WITH registered_users AS (
  SELECT
    COUNT(*) AS value,
    DATE(created_at) AS date
  FROM
    users
  GROUP BY
    date
  ORDER BY
    date
)
SELECT
  registered_users.date,
  COALESCE(registered_users.value, 0) AS value,
  0 as target
FROM
  registered_users
WHERE
  registered_users.date > { start_time }
  AND registered_users.date < { end_time }
