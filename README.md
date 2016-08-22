# SQLQuery

A package for representing sql queries, and converting them to valid SQL
statements. The generated SQL statements follow the specification in
https://www.sqlite.org/lang_select.html, and should conform to
http://www.sqlstyle.guide/ as far as possible.

This package is currently under development and is not registered.

It allows for user-defined verbs (e.g. to capture common SQL idioms) that composes well with the rest of the verbs provided here. It is the intention of this package to allow for further customizations (e.g. different string or identifier quotes, or to recognize [additional functions](http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html) for different backends).

```julia
  | | |_| | | | (_| |  |  Version 0.5.0-rc1+1 (2016-08-05 15:23 UTC)
 _/ |\__'_|_|_|\__'_|  |  Commit acfd04c (9 days old release-0.5)
|__/                   |  x86_64-apple-darwin13.4.0

julia> using SQLQuery

julia> type NewNode{T} <: SQLQuery.QueryNode
           input::T
           args
       end

julia> SQLQuery.QUERYNODE[:newnode] = NewNode
NewNode{T}

julia> SQLQuery.translatesql(nn::NewNode, offset::Int) = "newnode, offset=$offset"

julia> @sqlquery source |> newnode(are, you.serious) |> select(*, some, columns)
SELECT *,
       some,
       columns
  FROM (newnode, offset=8)
```

Some examples for geospatial queries (based on [ArchGDAL](https://github.com/yeesian/ArchGDAL.jl)):
```julia
  | | |_| | | | (_| |  |  Version 0.4.6 (2016-06-19 17:16 UTC)
 _/ |\__'_|_|_|\__'_|  |  Official http://julialang.org/ release
|__/                   |  x86_64-apple-darwin13.4.0

julia> import ArchGDAL; const AG = ArchGDAL
ArchGDAL

julia> using SQLQuery
WARNING: Base.String is deprecated, use AbstractString instead.
  likely near /Users/yeesian/.julia/v0.4/SQLQuery/src/expressions.jl:8

julia> macro inspect(args...)
           AG.registerdrivers() do
               AG.read("../test/spatialite-tutorial/test-2.3.sqlite") do dataset
                   sqlcommand = SQLQuery.translatesql(SQLQuery._sqlquery(args))
                   AG.executesql(dataset, sqlcommand) do results
                       print(results)
                   end
               end
           end
       end

julia> @inspect towns |>
       select(*) |>
       limit(5)
Layer: SELECT, nfeatures = 5
  Geometry 0 (Geometry): [wkbUnknown], POINT (427002.77 499...), ...
     Field 0 (PK_UID): [OFTInteger], 1, 2, 3, 4, 5
     Field 1 (Name): [OFTString], Brozolo, Campiglione-Fenile, Canischio, ...
     Field 2 (Peoples): [OFTInteger], 435, 1284, 274, 2281, 1674
     Field 3 (LocalCounc): [OFTInteger], 1, 1, 1, 1, 1
     Field 4 (County): [OFTInteger], 0, 0, 0, 0, 0
...
 Number of Fields: 6
julia> @inspect towns |>
       select(name, peoples) |>
       filter(peoples > 350000) |>
       orderby(desc(peoples))
Layer: SELECT, nfeatures = 8
     Field 0 (name): [OFTString], Roma, Milano, Napoli, Torino, Palermo, ...
     Field 1 (peoples): [OFTInteger], 2546804, 1256211, 1004500, 865263, ...
false

julia> @inspect towns |>
       select(
       ntowns = count(*),
       smaller = min(peoples),
       bigger = max(peoples),
       totalpeoples = sum(peoples),
       meanpeoples = sum(peoples) / count(*))
Layer: SELECT, nfeatures = 1
     Field 0 (ntowns): [OFTInteger], 8101
     Field 1 (smaller): [OFTInteger], 33
     Field 2 (bigger): [OFTInteger], 2546804
     Field 3 (totalpeoples): [OFTInteger], 57006147
     Field 4 (meanpeoples): [OFTInteger], 7036
false

julia> @inspect towns |>
       select(name, peoples, hex(Geometry)) |>
       filter(peoples > 350000) |>
       orderby(desc(peoples))
Layer: SELECT, nfeatures = 8
     Field 0 (name): [OFTString], Roma, Milano, Napoli, Torino, Palermo, ...
     Field 1 (peoples): [OFTInteger], 2546804, 1256211, 1004500, 865263, ...
     Field 2 (hex(Geometry)): [OFTString], 0001787F00003D0AD723..., ...
false

julia> @inspect towns |>
       select(name, peoples, astext(geometry)) |>
       filter(peoples > 350000) |>
       orderby(desc(peoples))
Layer: SELECT, nfeatures = 8
     Field 0 (name): [OFTString], Roma, Milano, Napoli, Torino, Palermo, ...
     Field 1 (peoples): [OFTInteger], 2546804, 1256211, 1004500, 865263, ...
     Field 2 (ST_AsText(geometry)): [OFTString], POINT(788703.57 4645..., ...
false

julia> @inspect highways |>
       select(PK_UID, npts = npoint(geometry), astext(startpoint(geometry)),
       astext(endpoint(geometry)), x(nthpoint(geometry,2)),
       y(nthpoint(geometry,2))) |>
       orderby(desc(npts))
Layer: SELECT, nfeatures = 775
     Field 0 (PK_UID): [OFTInteger], 774, 775, 153, 205, 773, 767, 207, 151, ...
     Field 1 (npts): [OFTInteger], 6758, 5120, 4325, 3109, 2755, 2584, 2568, ...
     Field 2 (ST_AsText(ST_StartPoint(geometry))): [OFTString], ...
     Field 3 (ST_AsText(ST_EndPoint(geometry))): [OFTString], ...
     Field 4 (ST_X(ST_PointN(geometry,2))): [OFTReal], 632086.0096648833, ...
...
 Number of Fields: 6
julia> @inspect regions |>
       select(PK_UID,
       nintrings = ninteriorring(geometry),
       nexteriorpoints = npoint(exteriorring(geometry)),
       npoint(nthinteriorring(geometry,1))) |>
       orderby(desc(nintrings))
Layer: SELECT, nfeatures = 109
     Field 0 (PK_UID): [OFTInteger], 55, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, ...
     Field 1 (nintrings): [OFTInteger], 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
     Field 2 (nexteriorpoints): [OFTInteger], 602, 6, 12, 20, 7, 805, 12, ...

julia> @inspect regions |>
       filter(PK_UID == 55) |>
       select(intring1 = astext(nthinteriorring(geometry,1)),
       point4 = astext(nthpoint(nthinteriorring(geometry,1),4)),
       pt5x = x(nthpoint(nthinteriorring(geometry,1),5)),
       pt5y = y(nthpoint(nthinteriorring(geometry,1),5)))
Layer: SELECT, nfeatures = 1
     Field 0 (intring1): [OFTString], LINESTRING(756881.70...
     Field 1 (point4): [OFTString], POINT(757549.382306 ...
     Field 2 (pt5x): [OFTReal], 755734.1893322569
     Field 3 (pt5y): [OFTReal], 4.856112118806925e6
```

You can inspect the SQL queries it generates:

```julia
  | | |_| | | | (_| |  |  Version 0.5.0-rc1+1 (2016-08-05 15:23 UTC)
 _/ |\__'_|_|_|\__'_|  |  Commit acfd04c (10 days old release-0.5)
|__/                   |  x86_64-apple-darwin13.4.0

julia> using SQLQuery

julia> @sqlquery source |>
       filter(name == 3, bar == "whee")
SELECT *
  FROM source
 WHERE name == 3
   AND bar == 'whee'

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col)
SELECT foo * 3 AS name,
       col
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == 'whee')

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       distinct(name = foo * 3, col)
SELECT DISTINCT foo * 3 AS name,
                col
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == 'whee')

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(name = foo * 3, col)
SELECT foo * 3 AS name,
       col
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == 'whee')

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       select(*)
SELECT *
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == 'whee')

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       distinct(*)
SELECT DISTINCT *
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == 'whee')

julia> @sqlquery source |>
       filter(name == 3, bar == "whee") |>
       distinct(col)
SELECT DISTINCT col
  FROM (SELECT *
          FROM source
         WHERE name == 3
           AND bar == 'whee')

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
                     AND bar == 'whee'))
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
                     AND bar == 'whee'))
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
                     AND bar == 'whee'))
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
                     AND bar == 'whee'))
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
                     AND bar == 'whee'))
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
                     AND bar == 'whee'))
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
                     AND bar == 'whee'))
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
                     AND bar == 'whee'))
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
                             AND bar == 'whee'))
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
                             AND bar == 'whee'))
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
