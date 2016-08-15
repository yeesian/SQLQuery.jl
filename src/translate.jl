# should escape column-names:
# http://stackoverflow.com/questions/2901453/sql-standard-to-escape-column-names
# https://www.sqlite.org/lang_keywords.html
ident(identifier::Symbol) = string(identifier)

function ident(identifier::Expr)
    @assert identifier.head == :.
    @assert length(identifier.args) == 2
    table,colname = identifier.args
    @assert isa(table, Symbol)
    @assert isa(colname, Expr)
    @assert colname.head == :quote
    @assert length(colname.args) == 1
    @assert isa(colname.args[1], Symbol)
    string(identifier)
end

# should process this properly in the future
_sqlexpr(ex::QueryArg) = "$ex"

translatesql(q::Symbol, offset::Int) = ident(q) # table-name
_translatesubquery(q::Symbol, offset::Int) = ident(q)
_translatesubquery(q::QueryNode, offset::Int) =
    "($(translatesql(q.input, offset)))"

_selectarg(a::Symbol) = string(a) # assume it corresponds to a column-name

function _selectarg(a::Expr)
    if a.head == :kw # newcol=col (SELECT col AS newcol)
        @assert length(a.args) == 2
        newcol,expr = a.args
        @assert isa(newcol, Symbol)
        return "$(_sqlexpr(expr)) AS $newcol"
    else
        @assert a.head == :. # table.columnname
        return ident(a)
    end
end

"Returns `true` is the last GROUP BY argument a `having(...)` expression"
_groupbyhaving(arg::QueryArg) =
    isa(arg, Expr) && arg.head == :call && arg.args[1] == :having

_orderbyterm(term::Symbol) = ident(term)
function _orderbyterm(term::QueryArg)
    if isa(term, Expr) && term.head == :call
        @assert length(term.args) == 2 "invalid orderby term: $term"
        order, identifier = term.args
        order == :asc && return "$(ident(identifier)) ASC"
        order == :desc && return "$(ident(identifier)) DESC"
    else
        return ident(term)
    end
    error("Unable to parse orderby term: $term")
end

function _parsejoinargs(q::JoinNode, offset::Int)
    nargs = length(q.args)
    @assert nargs > 0
    @assert isa(q.args[1], Symbol) "only support joining to a table-alias"
    indent = " " ^ offset
    on = by = ""
    source = string(q.args[1])
    if length(q.args) > 1 # has join constraints (e.g. join(t2, on(expr)))
        @assert length(q.args) == 2 "only allow for one constraint"
        constraint = q.args[2]
        @assert isa(constraint, Expr)
        @assert constraint.head == :call
        cons = exf(constraint); args = exfargs(constraint)
        if cons == :on
            # TODO: parse the arguments here
            on = "\n$(indent)ON $(join(args, "\n $indent  AND "))"
        else
            @assert cons == :by
            columnnames = join(map(ident,args),",\n       $indent")
            by = "\n$(indent)USING ($columnnames)"
        end
    end
    source, on, by
end

function _parsejoin(q::LeftJoinNode, offset::Int=0)
    source, on, by = _parsejoinargs(q, offset+17)
    "LEFT JOIN", source, on, by
end

function _parsejoin(q::OuterJoinNode, offset::Int=0)
    source, on, by = _parsejoinargs(q, offset+23)
    "LEFT OUTER JOIN", source, on, by
end

function _parsejoin(q::InnerJoinNode, offset::Int=0)
    source, on, by = _parsejoinargs(q, offset+18)
    "INNER JOIN", source, on, by
end

function _parsejoin(q::CrossJoinNode, offset::Int=0)
    source, on, by = _parsejoinargs(q, offset+18)
    "CROSS JOIN", source, on, by
end

function translatesql(q::FilterNode, offset::Int=0)
    @assert length(q.args) > 0 "you shouldn't filter by nothing"
    indent = " " ^ offset
    source = _translatesubquery(q.input, offset+8)
    # TODO: should properly parse q.args
    conditions = join(q.args, "\n$(indent)   AND ")
    "SELECT *\n $indent FROM $source\n$indent WHERE $conditions"
end

function translatesql(q::SelectNode, offset::Int=0)
    @assert length(q.args) > 0 "you shouldn't select by nothing"
    indent = " " ^ offset
    source = _translatesubquery(q.input, offset+8)
    resultcolumns = join(map(_selectarg, q.args), ",\n $indent      ")
    "SELECT $resultcolumns\n $indent FROM $source"
end

function translatesql(q::DistinctNode, offset::Int=0)
    @assert length(q.args) > 0 "you shouldn't select by nothing"
    indent = " " ^ offset; pad = " " ^ 9
    source = _translatesubquery(q.input, offset+8)
    resultcolumns = join(map(_selectarg, q.args), ",\n $indent$pad      ")
    "SELECT DISTINCT $resultcolumns\n $indent FROM $source"
end

function translatesql(q::GroupbyNode, offset::Int=0)
    @assert length(q.args) > 0 "you shouldn't groupby nothing"
    indent = " " ^ offset
    source = _translatesubquery(q.input, offset+10)
    lastarg = q.args[end]
    groupby = if _groupbyhaving(lastarg)
        groupbyargs = q.args[1:end-1]
        @assert length(groupbyargs) > 0
        havingargs = exfargs(lastarg)
        @assert length(havingargs) > 0
        # TODO: should properly parse havingargs
        conditions = "HAVING $(join(havingargs, "\n $indent    AND "))"
        "GROUP BY $(join(map(ident, groupbyargs), ", "))\n $conditions"
    else
        "GROUP BY $(join(map(ident, q.args), ", "))"
    end
    "  SELECT *\n   $indent FROM $source\n$(indent)$groupby"
end

function translatesql(q::OrderbyNode, offset::Int=0)
    @assert length(q.args) > 0 "you shouldn't order by nothing"
    indent = " " ^ offset
    source = _translatesubquery(q.input, offset+10)
    orderby = join(map(_orderbyterm, q.args), ",\n $indent        ")
    "  SELECT *\n   $indent FROM $source\n$(indent)ORDER BY $orderby"
end

function translatesql(q::LimitNode, offset::Int=0)
    indent = " " ^ offset
    source = _translatesubquery(q.input, offset+8)
    "SELECT *\n $indent FROM $source\n$(indent) LIMIT $(q.limit)"
end

function translatesql(q::OffsetNode, offset::Int=0)
    indent = " " ^ offset
    source = _translatesubquery(q.input, offset+8)
    limit = "LIMIT -1 OFFSET $(q.offset)"
    "SELECT *\n $indent FROM $source\n$(indent) $limit"
end

function translatesql(q::JoinNode, offset::Int=0)
    indent = " " ^ offset
    join, table, on, by = _parsejoin(q, offset)
    source = _translatesubquery(q.input, offset+8)
    "SELECT *\n $indent FROM $source\n       $indent$join $table$on$by"
end
