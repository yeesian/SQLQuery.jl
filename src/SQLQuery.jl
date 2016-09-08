module SQLQuery

using Reexport
@reexport using jplyr
@reexport using Tables
@reexport using SQLite
@reexport using DataStreams

export  SQLTable,
        SQLiteTable,
        translatesql

# Extend jplyr.QueryNode framework
include("querynode/typedefs.jl")

# SQLTable
include("sqltable/typedef.jl")

# SQLiteTable
include("sqlitetable/typedef.jl")

# Query interface
include("sqltable/query/collect.jl")
include("sqltable/query/translate.jl")

end
