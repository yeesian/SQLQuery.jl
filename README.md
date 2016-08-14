# SQLQuery

A package for representing sql queries, and converting them to valid SQL
statements. The generated SQL statements follow the specification in
https://www.sqlite.org/lang_select.html, and should conform to
http://www.sqlstyle.guide/ as far as possible.

This package is currently under development and is not registered.

```julia
  | | |_| | | | (_| |  |  Version 0.5.0-rc1+1 (2016-08-05 15:23 UTC)
 _/ |\__'_|_|_|\__'_|  |  Commit acfd04c (8 days old release-0.5)
|__/                   |  x86_64-apple-darwin13.4.0

julia> using SQLQuery

julia> @sqlquery source |>
       filter(name == 3, bar == "whee")
SELECT *
  FROM source
 WHERE name == 3
   AND bar == "whee"

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col)
SELECT foo * 3 AS name,
       col
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == "whee")

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(distinct(name = foo * 3, col))
SELECT DISTINCT foo * 3 AS name,
       col
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == "whee")

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(all(name = foo * 3, col))
SELECT ALL foo * 3 AS name,
       col
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == "whee")

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(all(*))
SELECT ALL *
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == "whee")

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(distinct(*))
SELECT DISTINCT *
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == "whee")

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(distinct(col))
SELECT DISTINCT col
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == "whee")

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(name)
  SELECT *
    FROM (SELECT foo * 3 AS name,
                 col
            FROM (SELECT *
                    FROM source
                   WHERE name == 3
                     AND bar == "whee"))
ORDER BY name

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(name, col)
  SELECT *
    FROM (SELECT foo * 3 AS name,
                 col
            FROM (SELECT *
                    FROM source
                   WHERE name == 3
                     AND bar == "whee"))
ORDER BY name,
         col

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(desc(name))
  SELECT *
    FROM (SELECT foo * 3 AS name,
                 col
            FROM (SELECT *
                    FROM source
                   WHERE name == 3
                     AND bar == "whee"))
ORDER BY name DESC

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(name, desc(col))
  SELECT *
    FROM (SELECT foo * 3 AS name,
                 col
            FROM (SELECT *
                    FROM source
                   WHERE name == 3
                     AND bar == "whee"))
ORDER BY name,
         col DESC

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(desc(name), desc(col))
  SELECT *
    FROM (SELECT foo * 3 AS name,
                 col
            FROM (SELECT *
                    FROM source
                   WHERE name == 3
                     AND bar == "whee"))
ORDER BY name DESC,
         col DESC

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(desc(name), asc(col))
  SELECT *
    FROM (SELECT foo * 3 AS name,
                 col
            FROM (SELECT *
                    FROM source
                   WHERE name == 3
                     AND bar == "whee"))
ORDER BY name DESC,
         col ASC

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(asc(name), asc(col))
  SELECT *
    FROM (SELECT foo * 3 AS name,
                 col
            FROM (SELECT *
                    FROM source
                   WHERE name == 3
                     AND bar == "whee"))
ORDER BY name ASC,
         col ASC

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(desc(name))
  SELECT *
    FROM (SELECT foo * 3 AS name,
                 col
            FROM (SELECT *
                    FROM source
                   WHERE name == 3
                     AND bar == "whee"))
ORDER BY name DESC

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(desc(name)) |>
       limit(10)
SELECT *
  FROM (  SELECT *
            FROM (SELECT foo * 3 AS name,
                         col
                    FROM (SELECT *
                            FROM source
                           WHERE name == 3
                             AND bar == "whee"))
        ORDER BY name DESC)
 LIMIT 10

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col) |>
       orderby(desc(name)) |>
       offset(7)
SELECT *
  FROM (  SELECT *
            FROM (SELECT foo * 3 AS name,
                         col
                    FROM (SELECT *
                            FROM source
                           WHERE name == 3
                             AND bar == "whee"))
        ORDER BY name DESC)
 LIMIT -1 OFFSET 7

julia> @sqlquery Artists |>
       leftjoin(Songs) |>
       leftjoin(Albums) |>
       select( song_id = Songs._id,
       song_name = Songs.name,
       Songs.length,
       artist_id = Songs.artist_id,
       artist_name = Artists.name,
       album_id = Songs.album_id,
       album_name = Albums.name)
SELECT Songs._id AS song_id,
       Songs.name AS song_name,
       Songs.length,
       Songs.artist_id AS artist_id,
       Artists.name AS artist_name,
       Songs.album_id AS album_id,
       Albums.name AS album_name
  FROM (SELECT *
          FROM (SELECT *
                  FROM Artists
                       LEFT JOIN Songs)
               LEFT JOIN Albums)

julia> @sqlquery Artists |>
       leftjoin(Songs) |>
       leftjoin(Albums) |>
       select( song_id = Songs._id,
       song_name = Songs.name,
       Songs.length,
       artist_id = Songs.artist_id,
       artist_name = Artists.name,
       album_id = Songs.album_id,
       album_name = Albums.name) |>
       groupby(Songs.length, artist_id)
  SELECT *
    FROM (SELECT Songs._id AS song_id,
                 Songs.name AS song_name,
                 Songs.length,
                 Songs.artist_id AS artist_id,
                 Artists.name AS artist_name,
                 Songs.album_id AS album_id,
                 Albums.name AS album_name
            FROM (SELECT *
                    FROM (SELECT *
                            FROM Artists
                                 LEFT JOIN Songs)
                         LEFT JOIN Albums))
GROUP BY Songs.length, artist_id

julia> @sqlquery Artists |>
       leftjoin(Songs) |>
       leftjoin(Albums) |>
       select( song_id = Songs._id,
       song_name = Songs.name,
       Songs.length,
       artist_id = Songs.artist_id,
       artist_name = Artists.name,
       album_id = Songs.album_id,
       album_name = Albums.name) |>
       groupby(Songs.length, artist_id) |>
       orderby(asc(song_id), desc(Songs.length), desc(artist_id))
  SELECT *
    FROM (  SELECT *
              FROM (SELECT Songs._id AS song_id,
                           Songs.name AS song_name,
                           Songs.length,
                           Songs.artist_id AS artist_id,
                           Artists.name AS artist_name,
                           Songs.album_id AS album_id,
                           Albums.name AS album_name
                      FROM (SELECT *
                              FROM (SELECT *
                                      FROM Artists
                                           LEFT JOIN Songs)
                                   LEFT JOIN Albums))
          GROUP BY Songs.length, artist_id)
ORDER BY song_id ASC,
         Songs.length DESC,
         artist_id DESC
```
