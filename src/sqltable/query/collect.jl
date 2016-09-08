AbstractTables.default(::SQLTable) = Table()

function Base.collect(tbl::SQLTable, graph::jplyr.QueryNode)
    jplyr.set_src!(graph, tbl)
    sql = translatesql(graph)
    source = SQLite.Source(tbl.db, sql)
    res = Table(Data.schema(source))
    Data.stream!(source, Data.Field, res, false)
    return res
end
