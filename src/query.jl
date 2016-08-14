macro sqlquery(args...)
    @assert isa(args, Tuple{Expr}) "Invalid Query Expression"
    _sqlquery(args)
end

_sqlquery(expr::Symbol) = expr
    _sqlquery(expr::Tuple{Expr}) = _sqlquery(expr[1])

function _sqlquery(ex::Expr)
    @assert ex.head == :call
    pipe = exf(ex); args = exfargs(ex)
    @assert pipe == :|>
    @assert length(args) == 2
    subquery, verb = args
    source = _sqlquery(subquery)
    @assert isa(source, QuerySource)
    @assert isa(verb, Expr)
    @assert verb.head == :call
    querytype = exf(verb); queryargs = exfargs(verb)
    @assert in(querytype, QUERYTYPES) "$querytype not allowed yet"
    querytype == :select && return _selectquery(source, queryargs)
    querytype == :filter && return _filterquery(source, queryargs)
    querytype == :groupby && return _groupbyquery(source, queryargs)
    querytype == :orderby && return _orderbyquery(source, queryargs)
    querytype == :limit && return _limitquery(source, queryargs)
    querytype == :offset && return _offsetquery(source, queryargs)
    querytype == :leftjoin && return _leftjoinquery(source, queryargs)
    querytype == :outerjoin && return _outerjoinquery(source, queryargs)
    querytype == :innerjoin && return _innerjoinquery(source, queryargs)
    querytype == :crossjoin && return _crossjoinquery(source, queryargs)
end

function _selectquery(source::QuerySource, args)
    @assert length(args) > 0 "you shouldn't select nothing"
    local queryargs::QueryArgs = args
    SelectNode(source, queryargs)
end

function _filterquery(source::QuerySource, args)
    @assert length(args) > 0 "you shouldn't filter nothing"
    local queryargs::Vector{Expr} = args
    FilterNode(source, queryargs)
end

function _groupbyquery(source::QuerySource, args)
    @assert length(args) > 0 "you shouldn't group by nothing"
    local queryargs::QueryArgs = args
    GroupbyNode(source, queryargs)
end

function _orderbyquery(source::QuerySource, args)
    @assert length(args) > 0 "you shouldn't order by nothing"
    local queryargs::QueryArgs = args
    OrderbyNode(source, queryargs)
end

function _limitquery(source::QuerySource, args)
    @assert length(args) == 1 "invalid limit term: $args"
    @assert isa(args[1], Integer)
    LimitNode(source, args[1])
end

function _offsetquery(source::QuerySource, args)
    @assert length(args) == 1 "invalid limit term: $args"
    @assert isa(args[1], Integer)
    OffsetNode(source, args[1])
end

function _leftjoinquery(source::QuerySource, args)
    @assert length(args) > 0 "you shouldn't leftjoin by nothing"
    local queryargs::QueryArgs = args
    LeftJoinNode(source, queryargs)
end

function _outerjoinquery(source::QuerySource, args)
    @assert length(args) > 0 "you shouldn't outerjoin by nothing"
    local queryargs::QueryArgs = args
    OuterJoinNode(source, queryargs)
end

function _innerjoinquery(source::QuerySource, args)
    @assert length(args) > 0 "you shouldn't innerjoin by nothing"
    local queryargs::QueryArgs = args
    InnerJoinNode(source, queryargs)
end

function _crossjoinquery(source::QuerySource, args)
    @assert length(args) > 0 "you shouldn't crossjoin by nothing"
    local queryargs::QueryArgs = args
    CrossJoinNode(source, queryargs)
end