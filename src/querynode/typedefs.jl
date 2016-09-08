# using jplyr: QueryNode, JoinNode,
typealias QueryArgs Vector{jplyr.QueryArg}
typealias QuerySource Union{Symbol, jplyr.QueryNode}

type DistinctNode <: jplyr.QueryNode
    input::jplyr.QueryNode
    args::QueryArgs
end

type LimitNode <: jplyr.QueryNode
    input::jplyr.QueryNode
    limit::Vector{Int}
end

type OffsetNode <: jplyr.QueryNode
    input::jplyr.QueryNode
    offset::Vector{Int}
end
