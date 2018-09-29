# users per day
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

# reviews per day

SELECT
  (
    DATE_TRUNC(
      'day',
      (created_at :: timestamptz - INTERVAL '0 second') AT TIME ZONE 'Etc/UTC'
    ) + INTERVAL '0 second'
  ) AT TIME ZONE 'Etc/UTC' AS date_trunc_day_created_at_timestampz_interval_0_second_at_time,
  COUNT(*) AS count_all
FROM
  "reviews"
WHERE
  (created_at IS NOT NULL)
GROUP BY(
    DATE_TRUNC(
      'day',
      (created_at :: timestamptz - INTERVAL '0 second') AT TIME ZONE 'Etc/UTC'
    ) + INTERVAL '0 second'
  ) AT TIME ZONE 'Etc/UTC'

SELECT
  date_trunc('month', rating) :: date AS month,
  gender,
  COUNT(*)
FROM
  reviews
  INNER JOIN users ON reviews.user_id = users.id
GROUP BY
  month,
  gender
ORDER BY
  month,
  gender

SELECT
  date_trunc('month', rating) :: date AS month,
  gender,
  COUNT(*)
FROM
  reviews
  INNER JOIN users ON reviews.user_id = users.id
GROUP BY
  month,
  gender
ORDER BY
  month,
  gender


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
