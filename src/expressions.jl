
function _sqlexprargs(ex::Expr)
    @assert ex.head == :call
    join(map(_sqlexpr,exfargs(ex)),",")
end

_sqlexpr(ex::Real) = string(ex)
_sqlexpr(ex::String) = "\'$ex\'"
_sqlexpr(ex::Symbol) = string(ex)

function _sqlexpr(ex::Expr)
    if ex.head == :call
        f = exf(ex); args = exfargs(ex)
        return get(SQLFUNCTION, f, _trysqlitefunction)(ex)
    elseif ex.head == :.
        return ident(ex)
    end
    error("Unrecognized expression: $ex")
end

function _trysqlitefunction(ex::Expr)
    if ex.head == :call
        f = exf(ex); args = exfargs(ex)
        return get(SQLITEFUNCTION, f, _tryuserfunction)(ex)
    end
    error("Unrecognized expression: $ex")
end

function _tryuserfunction(ex::Expr)
    if ex.head == :call
        f = exf(ex); args = exfargs(ex)
        return get(USERFUNCTION, f, _unrecognizedexpr)(ex)
    end
    error("Unrecognized expression: $ex")
end

function _unrecognizedexpr(ex::Expr)
    warn("Unrecognized expression: $ex")
    return "$ex"
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

"""
The like() function is used to implement the \"Y LIKE X [ESCAPE Z]\" expression.

If the optional ESCAPE clause is present, then the like() function is invoked
with three arguments. Otherwise, it is invoked with two arguments only. Note 
that the X and Y parameters are reversed in the like() function relative to the
infix LIKE operator.

The sqlite3_create_function() interface can be used to override the like() 
function and thereby change the operation of the LIKE operator. When overriding
the like() function, it may be important to override both the two and three 
argument versions of the like() function. Otherwise, different code may be 
called to implement the LIKE operator depending on whether or not an ESCAPE
clause was specified.
"""
function _like(ex::Expr)
    @assert ex.head == :call
    if length(ex.args) == 3
        return "($(_sqlexpr(ex.args[2])) LIKE $(_sqlexpr(ex.args[3])))"
    else
        @assert length(ex.args) == 4 # for SQLite
        return "like($(_sqlexprargs(ex)))"
    end
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
    "$(_sqlexpr(left)) $op $(_sqlexpr(right))"
end

const SQLFUNCTION = Dict{Symbol, Function}(
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

USERFUNCTION = Dict{Symbol, Function}()