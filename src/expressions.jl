_sqlexpr(ex::Real) = string(ex)
_sqlexpr(ex::String) = ex
_sqlexpr(ex::Symbol) = string(ex)

function _unrecognizedexpr(ex::Expr)
    warn("Unrecognized expression: $ex")
    return "$ex"
end

function _sqlexpr(ex::Expr)
    if ex.head == :call
        f = exf(ex); args = exfargs(ex)
        return get(SQLFUNCTION, f, _unrecognizedexpr)(ex)
    end
    error("Unrecognized expression: $ex")
end

function _is(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 3
    "($(_sqlexpr(args[1])) IS $(_sqlexpr(args[2])))"
end

function _not(ex::Expr)
    @assert ex.head == :call
    if length(ex.args) == 3
        return "($(_sqlexpr(ex.args[2])) IS NOT $(_sqlexpr(ex.args[3])))"
    else
        @assert length(args) == 2
        return "(NOT $(_sqlexpr(ex.args[2])))"
    end
end

function _isnull(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "($(_sqlexpr(ex.args[2])) ISNULL)"
end

function _notnull(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "($(_sqlexpr(ex.args[2])) NOTNULL)"
end

function _like(ex::Expr)
    @assert ex.head == :call
    @assert length(args) == 3
    "($(_sqlexpr(ex.args[2])) LIKE $(_sqlexpr(ex.args[3])))"
end

function _glob(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 3
    "($(_sqlexpr(ex.args[2])) GLOB $(_sqlexpr(ex.args[2])))"
end

function _regexp(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "($(_sqlexpr(ex.args[2])) REGEXP $(_sqlexpr(ex.args[3])))"
end

function _match(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 3
    "($(_sqlexpr(ex.args[2])) MATCH $(_sqlexpr(ex.args[3])))"
end

function _cast(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 3
    "(CAST ($(_sqlexpr(ex.args[2])) AS $(_sqlexpr(ex.args[3]))))"
end

function _operator(ex::Expr)
    @assert ex.head == :call
    if length(ex.args) == 2
        return _unaryop(ex)
    else
        @assert length(ex.args) == 3
        return _binaryop(ex)
    end
end

function _unaryop(ex::Expr)
    const unaryops = Set(Symbol[:(-), :(+), :(~)])
    @assert ex.head == :call
    @assert length(ex.args) == 2
    op = exf(ex); @assert in(op, unaryops)
    "$op$(_sqlexpr(ex.args[2]))"
end

function _binaryop(ex::Expr)
    const binaryops = Set(Symbol[:(||),:(*),:(/),:(%), :(+),:(-), :(<<),:(>>),
                                 :(&), :(|),:(<),:(<=),:(>),:(>=),:(==),:(!=)])
    @assert ex.head == :call
    @assert length(ex.args) == 3
    op = exf(ex); left, right = exfargs(ex)
    @assert in(op, binaryops)
    "$(_sqlexpr(left))$op$(_sqlexpr(right))"
end

SQLFUNCTION = Dict{Symbol, Function}(
    :is =>      _is,
    :not =>     _not,
    :isnull =>  _isnull,
    :notnull => _notnull,
    :like =>    _like,
    :glob =>    _glob,
    :regexp =>  _regexp,
    :match =>   _match,
    :cast =>    _cast,

    # binary operators
    :(||) =>    _binaryop,
    :(*) =>     _binaryop,
    :(/) =>     _binaryop,
    :(%) =>     _binaryop,
    :(<<) =>    _binaryop,
    :(>>) =>    _binaryop,
    :(&) =>     _binaryop,
    :(|) =>     _binaryop,
    :(<) =>     _binaryop,
    :(<=) =>    _binaryop,
    :(>) =>     _binaryop,
    :(>=) =>    _binaryop,
    :(==) =>    _binaryop,
    :(!=) =>    _binaryop,

    # unary operators
    :(~) =>     _unaryop,

    # binary/unary operators
    :(+) =>     _operator,
    :(-) =>     _operator
)
