module SQLQuery

    export @sqlquery, translatesql

     abstract QueryNode{T}
     abstract JoinNode{T} <: QueryNode{T}
    typealias QuerySource Union{Symbol, QueryNode}

    type SelectNode{T} <: QueryNode{T}
        input::T
        args::Vector
    end

    type DistinctNode{T} <: QueryNode{T}
        input::T
        args::Vector
    end

    type FilterNode{T} <: QueryNode{T}
        input::T
        args::Vector{Expr}
    end

    type GroupbyNode{T} <: QueryNode{T}
        input::T
        args::Vector
    end

    type OrderbyNode{T} <: QueryNode{T}
        input::T
        args::Vector
    end

    type LimitNode{T} <: QueryNode{T}
        input::T
        limit::Vector{Int}
    end

    type OffsetNode{T} <: QueryNode{T}
        input::T
        offset::Vector{Int}
    end

    type LeftJoinNode{T} <: JoinNode{T}
        input::T
        args::Vector
    end

    type OuterJoinNode{T} <: JoinNode{T}
        input::T
        args::Vector
    end

    type InnerJoinNode{T} <: JoinNode{T}
        input::T
        args::Vector
    end

    type CrossJoinNode{T} <: JoinNode{T}
        input::T
        args::Vector
    end

    Base.show(io::IO, q::QueryNode) = print(io, translatesql(q))

    QUERYNODE = Dict(:select => SelectNode,
                     :distinct => DistinctNode,
                     :filter => FilterNode,
                     :groupby => GroupbyNode,
                     :orderby => OrderbyNode,
                     :limit => LimitNode,
                     :offset => OffsetNode,
                     :leftjoin => LeftJoinNode,
                     :outerjoin => OuterJoinNode,
                     :innerjoin => InnerJoinNode,
                     :crossjoin => CrossJoinNode)

        exf(ex::Expr) = ex.args[1]
    exfargs(ex::Expr) = ex.args[2:end]

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
        QUERYNODE[querytype]{typeof(source)}(source, queryargs)
    end

    include("translate.jl")
    include("expressions.jl")
    include("sqlitefunctions.jl")
    include("spatialitefunctions.jl")
end
