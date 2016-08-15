using SQLQuery

type NewNode{T} <: SQLQuery.QueryNode
    input::T
    args
end

SQLQuery.QUERYNODE[:newnode] = NewNode

SQLQuery.translatesql(nn::NewNode, offset::Int) = "newnode, offset=$offset"

@sqlquery source |>
newnode(are, you.serious) |>
select(*, some, columns)

@sqlquery source |>
filter(name == 3, bar == "whee")

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col)

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(distinct(name = foo * 3, col))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(all(name = foo * 3, col))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(all(*))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(distinct(*))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(distinct(col))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(name)

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(name, col)

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(name, desc(col))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name), desc(col))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name), asc(col))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(asc(name), asc(col))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name))

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name)) |>
limit(10)

@sqlquery source |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name)) |>
offset(7) |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name)) |>
offset(7) |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name)) |>
offset(7) |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name)) |>
offset(7) |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name)) |>
offset(7) |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name)) |>
offset(7) |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name)) |>
offset(7) |>
filter(name == 3, bar == "whee") |>
select(name = foo * 3, col) |>
orderby(desc(name)) |>
offset(7)

@sqlquery Artists |>
leftjoin(Songs) |>
leftjoin(Albums) |>
select( song_id = Songs._id,
song_name = Songs.name,
Songs.length,
artist_id = Songs.artist_id,
artist_name = Artists.name,
album_id = Songs.album_id,
album_name = Albums.name)

@sqlquery Artists |>
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

@sqlquery Artists |>
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

