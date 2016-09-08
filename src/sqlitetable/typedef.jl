"""
"""
type SQLiteTable <: SQLTable
    db::SQLite.DB
    tbl_name
end

(::Type{SQLiteTable})(db::AbstractString, tbl_name::AbstractString) =
    SQLiteTable(SQLite.DB(db), tbl_name)

(::Type{SQLiteTable})(tbl_name::AbstractString) =
    SQLiteTable(SQLite.DB(), tbl_name)
