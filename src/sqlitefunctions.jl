"""
The abs(X) function returns the absolute value of the numeric argument X.

Abs(X) returns NULL if X is NULL. Abs(X) returns 0.0 if X is a string or blob
that cannot be converted to a numeric value. If X is the integer
-9223372036854775808 then abs(X) throws an integer overflow error since there 
is no equivalent positive 64-bit two complement value.
"""
function _abs(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args)==2
    "abs($(_sqlexpr(ex.args[2])))"
end

"""
The coalesce() function returns a copy of its first non-NULL argument, or NULL
if all arguments are NULL. Coalesce() must have at least 2 arguments.
"""
function _coalesce(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) >= 3 "Coalesce() must have at least 2 arguments."
    "coalesce($(_sqlexprargs(ex)))"
end

"""
The ifnull() function returns a copy of its first non-NULL argument, or NULL if
both arguments are NULL. Ifnull() must have exactly 2 arguments.

The ifnull() function is equivalent to coalesce() with two arguments.
"""
function _ifnull(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 3 "Ifnull() must have exactly 2 arguments."
    "ifnull($(_sqlexprargs(ex)))"
end

"""
The instr(X,Y) function finds the first occurrence of string Y within string X
and returns the number of prior characters plus 1, or 0 if Y is nowhere found
within X. Or, if X and Y are both BLOBs, then instr(X,Y) returns one more than
the number bytes prior to the first occurrence of Y, or 0 if Y does not occur
anywhere within X. If both arguments X and Y to instr(X,Y) are non-NULL and are
not BLOBs then both are interpreted as strings. If either X or Y are NULL in
instr(X,Y) then the result is NULL.
"""
function _instr(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 3
    "instr($(_sqlexprargs(ex)))"
end

"""
The `hex(input)` function interprets `input` as a BLOB and returns a string
which is the upper-case hexadecimal rendering of the content of that blob.
"""
function _hex(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "hex($(_sqlexprargs(ex)))"
end

"""
For a string value X, the length(X) function returns the number of characters
(not bytes) in X prior to the first NUL character. Since SQLite strings do not
normally contain NUL characters, the length(X) function will usually return the
total number of characters in the string X. For a blob value X, length(X)
returns the number of bytes in the blob. If X is NULL then length(X) is NULL.
If X is numeric then length(X) returns the length of a string representation
of X.
"""
function _length(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "length($(_sqlexprargs(ex)))"
end

"""
The likelihood(X,Y) function returns argument X unchanged. The value Y in 
likelihood(X,Y) must be a floating point constant between 0.0 and 1.0, 
inclusive. The likelihood(X) function is a no-op that the code generator 
optimizes away so that it consumes no CPU cycles during run-time (that is, 
during calls to sqlite3_step()). The purpose of the likelihood(X,Y) function is 
to provide a hint to the query planner that the argument X is a boolean that is
true with a probability of approximately Y. The unlikely(X) function is 
short-hand for likelihood(X,0.0625). The likely(X) function is short-hand for 
likelihood(X,0.9375).
"""
function _likelihood(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 3
    "likelihood($(_sqlexprargs(ex)))"
end

"""
The likely(X) function returns the argument X unchanged. The likely(X) function
is a no-op that the code generator optimizes away so that it consumes no CPU
cycles at run-time (that is, during calls to sqlite3_step()). The purpose of 
the likely(X) function is to provide a hint to the query planner that the 
argument X is a boolean value that is usually true. The likely(X) function is 
equivalent to likelihood(X,0.9375). See also: unlikely(X).
"""
function _likely(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "likely($(_sqlexprargs(ex)))"
end

"""
The load_extension(X,Y) function loads SQLite extensions out of the shared
library file named X using the entry point Y. The result of load_extension() is
always a NULL. If Y is omitted then the default entry point name is used. The
load_extension() function raises an exception if the extension fails to load or
initialize correctly.
"""
function _loadextension(ex::Expr)
    @assert ex.head == :call
    @assert 2 <= length(ex.args) <= 3
    "load_extension($(_sqlexprargs(ex)))"
end

"""
The lower(X) function returns a copy of string X with all ASCII characters
converted to lower case. The default built-in lower() function works for ASCII
characters only. To do case conversions on non-ASCII characters, load the ICU
extension.
"""
function _lower(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "lower($(_sqlexprargs(ex)))"
end

"""
The ltrim(X,Y) function returns a string formed by removing any and all
characters that appear in Y from the left side of X. If the Y argument is
omitted, ltrim(X) removes spaces from the left side of X.
"""
function _ltrim(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "ltrim($(_sqlexprargs(ex)))"
end

"""
The multi-argument max() function returns the argument with the maximum value,
or return NULL if any argument is NULL.

The multi-argument max() function searches its arguments from left to right for
an argument that defines a collating function and uses that collating function
for all string comparisons. If none of the arguments to max() define a
collating function, then the BINARY collating function is used. Note that max()
is a simple function when it has 2 or more arguments but operates as an
aggregate function if given only a single argument.

The max() aggregate function returns the maximum value of all values in the
group. The maximum value is the value that would be returned last in an ORDER
BY on the same column. Aggregate max() returns NULL if and only if there are
no non-NULL values in the group.
"""
_max(ex::Expr) = "max($(_sqlexprargs(ex)))"

"""
The multi-argument min() function returns the argument with the minimum value.

The multi-argument min() function searches its arguments from left to right for
an argument that defines a collating function and uses that collating function
for all string comparisons. If none of the arguments to min() define a collating
function, then the BINARY collating function is used. Note that min() is a
simple function when it has 2 or more arguments but operates as an aggregate
function if given only a single argument.

The min() aggregate function returns the minimum non-NULL value of all values
in the group. The minimum value is the first non-NULL value that would appear
in an ORDER BY of the column. Aggregate min() returns NULL if and only if
there are no non-NULL values in the group.
"""
_min(ex::Expr) = "min($(_sqlexprargs(ex)))"

"""
The nullif(X,Y) function returns its first argument if the arguments are
different and NULL if the arguments are the same. The nullif(X,Y) function
searches its arguments from left to right for an argument that defines a
collating function and uses that collating function for all string comparisons.
If neither argument to nullif() defines a collating function then the BINARY is
used.
"""
function _nullif(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 3
    "nullif($(_sqlexprargs(ex)))"
end

"""
The printf(FORMAT,...) SQL function works like the sqlite3_mprintf()
C-language function and the printf() function from the standard C library. The
first argument is a format string that specifies how to construct the output
string using values taken from subsequent arguments. If the FORMAT argument is
missing or NULL then the result is NULL. The %n format is silently ignored and
does not consume an argument. The %p format is an alias for %X. The %z format
is interchangeable with %s. If there are too few arguments in the argument
list, missing arguments are assumed to have a NULL value, which is translated
into 0 or 0.0 for numeric formats or an empty string for %s.
"""
_printf(ex::Expr) = "printf($(_sqlexprargs(ex)))"

"""
The quote(X) function returns the text of an SQL literal which is the value of
its argument suitable for inclusion into an SQL statement. Strings are
surrounded by single-quotes with escapes on interior quotes as needed. BLOBs
are encoded as hexadecimal literals. Strings with embedded NUL characters
cannot be represented as string literals in SQL and hence the returned string
literal is truncated prior to the first NUL.
"""
function _quote(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "quote($(_sqlexprargs(ex)))"
end

"""
The random() function returns a pseudo-random integer between
-9223372036854775808 and +9223372036854775807.
"""
_random(ex::Expr) = "random()"

"""
The randomblob(N) function return an N-byte blob containing pseudo-random
bytes. If N is less than 1 then a 1-byte random blob is returned. Hint:
applications can generate globally unique identifiers using this function
together with hex() and/or lower() like this:

    hex(randomblob(16))
    lower(hex(randomblob(16)))

"""
function _randomblob(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "randomblob($(_sqlexprargs(ex)))"
end

"""
The replace(X,Y,Z) function returns a string formed by substituting string Z
for every occurrence of string Y in string X. The BINARY collating sequence is
used for comparisons. If Y is an empty string then return X unchanged. If Z is
not initially a string, it is cast to a UTF-8 string prior to processing.
"""
function _replace(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 4
    "replace($(_sqlexprargs(ex)))"
end

"""
The round(X,Y) function returns a floating-point value X rounded to Y digits
to the right of the decimal point. If the Y argument is omitted, it is assumed
to be 0.
"""
function _round(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) <= 3
    "round($(_sqlexprargs(ex)))"
end

"""
The rtrim(X,Y) function returns a string formed by removing any and all
characters that appear in Y from the right side of X. If the Y argument is
omitted, rtrim(X) removes spaces from the right side of X.
"""
function _rtrim(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) <= 3
    "rtrim($(_sqlexprargs(ex)))"
end

"""
The substr(X,Y,Z) function returns a substring of input string X that begins
with the Y-th character and which is Z characters long. If Z is omitted then
substr(X,Y) returns all characters through the end of the string X beginning
with the Y-th. The left-most character of X is number 1. If Y is negative then
the first character of the substring is found by counting from the right
rather than the left. If Z is negative then the abs(Z) characters preceding
the Y-th character are returned. If X is a string then characters indices
refer to actual UTF-8 characters. If X is a BLOB then the indices refer to
bytes.
"""
function _substr(ex::Expr)
    @assert ex.head == :call
    @assert 3 <= length(ex.args) <= 4
    "substr($(_sqlexprargs(ex)))"
end

"""
The trim(X,Y) function returns a string formed by removing any and all
characters that appear in Y from both ends of X. If the Y argument is omitted,
trim(X) removes spaces from both ends of X.
"""
function _trim(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) <= 3
    "trim($(_sqlexprargs(ex)))"
end

"""
The typeof(X) function returns a string that indicates the datatype of the
expression X: "null", "integer", "real", "text", or "blob".
"""
function _typeof(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "typeof($(_sqlexprargs(ex)))"
end

"""
The unicode(X) function returns the numeric unicode code point corresponding
to the first character of the string X. If the argument to unicode(X) is not a
string then the result is undefined.
"""
function _unicode(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "unicode($(_sqlexprargs(ex)))"
end

"""
The upper(X) function returns a copy of input string X in which all lower-case
ASCII characters are converted to their upper-case equivalent.
"""
function _upper(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "upper($(_sqlexprargs(ex)))"
end

"""
The zeroblob(N) function returns a BLOB consisting of N bytes of 0x00. SQLite
manages these zeroblobs very efficiently. Zeroblobs can be used to reserve
space for a BLOB that is later written using incremental BLOB I/O.
"""
function _zeroblob(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "zeroblob($(_sqlexprargs(ex)))"
end

_date(ex::Expr) = "date($(_sqlexprargs(ex)))"
_time(ex::Expr) = "time($(_sqlexprargs(ex)))"
_datetime(ex::Expr) = "datetime($(_sqlexprargs(ex)))"
_julianday(ex::Expr) = "julianday($(_sqlexprargs(ex)))"
_strftime(ex::Expr) = "strftime($(_sqlexprargs(ex)))"

# https://www.sqlite.org/lang_aggfunc.html
"""
The avg() function returns the average value of all non-NULL X within a group.
String and BLOB values that do not look like numbers are interpreted as 0. The
result of avg() is always a floating point value as long as at there is at
least one non-NULL input even if all inputs are integers. The result of avg()
is NULL if and only if there are no non-NULL inputs.
"""
function _avg(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "avg($(_sqlexprargs(ex)))"
end

"""
The count(X) function returns a count of the number of times that X is not
NULL in a group. The count(*) function (with no arguments) returns the total
number of rows in the group.
"""
function _count(ex::Expr)
    @assert ex.head == :call
    if length(ex.args) == 1
        return "count(*)"
    else
        @assert length(ex.args) == 2
        "count($(_sqlexprargs(ex)))"
    end
end

"""
The group_concat(X[,Y]) function returns a string which is the concatenation
of all non-NULL values of X. If parameter Y is present then it is used as the
separator between instances of X. A comma (",") is used as the separator if Y
is omitted. The order of the concatenated elements is arbitrary.
"""
function _groupconcat(ex::Expr)
    @assert ex.head == :call
    @assert 2 <= length(ex.args) <= 3
    "group_concat($(_sqlexprargs(ex)))"
end

"""
The sum() and total() aggregate functions return sum of all non-NULL values in
the group. If there are no non-NULL input rows then sum() returns NULL but
total() returns 0.0. NULL is not normally a helpful result for the sum of no
rows but the SQL standard requires it and most other SQL database engines
implement sum() that way so SQLite does it in the same way in order to be
compatible. The non-standard total() function is provided as a convenient way
to work around this design problem in the SQL language. The result of total()
is always a floating point value. The result of sum() is an integer value if
all non-NULL inputs are integers. If any input to sum() is neither an integer
or a NULL then sum() returns a floating point value which might be an
approximation to the true sum.
"""
function _sum(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "sum($(_sqlexprargs(ex)))"
end

"""
The sum() and total() aggregate functions return sum of all non-NULL values in
the group. If there are no non-NULL input rows then sum() returns NULL but
total() returns 0.0. NULL is not normally a helpful result for the sum of no
rows but the SQL standard requires it and most other SQL database engines
implement sum() that way so SQLite does it in the same way in order to be
compatible. The non-standard total() function is provided as a convenient way
to work around this design problem in the SQL language. The result of total()
is always a floating point value. The result of sum() is an integer value if
all non-NULL inputs are integers. If any input to sum() is neither an integer
or a NULL then sum() returns a floating point value which might be an
approximation to the true sum.
"""
function _total(ex::Expr)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    "total($(_sqlexprargs(ex)))"
end

const SQLITEFUNCTION = Dict{Symbol, Function}(
    # core functions
    # https://www.sqlite.org/lang_corefunc.html
    :abs                => _abs,
    :coalesce           => _coalesce,
    :ifnull             => _ifnull,
    :instr              => _instr,
    :hex                => _hex,
    :length             => _length,
    :like               => _like,
    :likelihood         => _likelihood,
    :likely             => _likely,
    :load_extension     => _loadextension,
    :lower              => _lower,
    :ltrim              => _ltrim,
    :max                => _max,
    :min                => _min,
    :nullif             => _nullif,
    :printf             => _printf,
    :quote              => _quote,
    :random             => _random,
    :randomblob         => _randomblob,
    :replace            => _replace,
    :round              => _round,
    :rtrim              => _rtrim,
    :substr             => _substr,
    :trim               => _trim,
    :typeof             => _typeof,
    :unicode            => _unicode,
    :upper              => _upper,
    :zeroblob           => _zeroblob,

    # date&time functions
    # https://www.sqlite.org/lang_datefunc.html
    :date               => _date,
    :time               => _time,
    :datetime           => _datetime,
    :julianday          => _julianday,
    :strftime           => _strftime,

    # aggregate functions
    # https://www.sqlite.org/lang_aggfunc.html
    :mean               => _avg,
    :count              => _count,
    :groupconcat        => _groupconcat,
    :sum                => _sum,
    :total              => _total
)
