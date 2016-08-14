module SQLQuery

    export @sqlquery, translatesql

     abstract QueryNode{T}
     abstract JoinNode{T} <: QueryNode{T}
    typealias QueryArg Union{Symbol, Expr}
    typealias QueryArgs Vector{QueryArg}
    typealias QuerySource Union{Symbol, QueryNode}

        exf(ex::Expr) = ex.args[1]
    exfargs(ex::Expr) = ex.args[2:end]

    type SelectNode{T} <: QueryNode{T}
        input::T
        args::QueryArgs
    end

    type FilterNode{T} <: QueryNode{T}
        input::T
        args::Vector{Expr}
    end

    type GroupbyNode{T} <: QueryNode{T}
        input::T
        args::QueryArgs
    end

    type OrderbyNode{T} <: QueryNode{T}
        input::T
        args::QueryArgs
    end

    type LimitNode{T} <: QueryNode{T}
        input::T
        limit::Int
    end

    type OffsetNode{T} <: QueryNode{T}
        input::T
        offset::Int
    end

    type LeftJoinNode{T} <: JoinNode{T}
        input::T
        args::QueryArgs
    end

    type OuterJoinNode{T} <: JoinNode{T}
        input::T
        args::QueryArgs
    end

    type InnerJoinNode{T} <: JoinNode{T}
        input::T
        args::QueryArgs
    end

    type CrossJoinNode{T} <: JoinNode{T}
        input::T
        args::QueryArgs
    end

    Base.show(io::IO, q::QueryNode) = print(io, translatesql(q))

    const QUERYTYPES = Set([:select, :filter, :groupby, :orderby, :limit,
                            :offset, :leftjoin, :outerjoin, :innerjoin,
                            :crossjoin])
    
    include("query.jl")
    include("translate.jl")
end
