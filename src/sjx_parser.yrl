%% -----------------------------------------------------------------------------
%% Copyright (c) 2002-2012 Tim Watson (watson.timothy@gmail.com)
%%
%% Permission is hereby granted, free of charge, to any person obtaining a copy
%% of this software and associated documentation files (the "Software"), to deal
%% in the Software without restriction, including without limitation the rights
%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the Software is
%% furnished to do so, subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in
%% all copies or substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%% THE SOFTWARE.
%% -----------------------------------------------------------------------------
%% @doc this is the grammar definition for the JMS Selector parser.
%% -----------------------------------------------------------------------------
Nonterminals 
expressions expression identifier rvalue operator list list_items
number string range_test.

Terminals '(' ')' ','
ident lit_string lit_int lit_flt lit_hex
op_cmp op_null op_between op_like op_not op_in op_arith op_and op_or.

Rootsymbol expressions.

expressions -> expression                       : ['$1'].
expressions -> '(' expression ')'               : ['$2'].
expressions -> expression op_and expressions    : union('$2', '$1', '$3').
expressions -> expression op_or expressions     : union('$2', '$1', '$3').

expression  -> identifier op_null               : unary_cmp(value_of('$2'), '$1').
expression  -> identifier range_test            : binary_cmp('between', '$1', '$2').
expression  -> identifier operator rvalue       : binary_cmp('$2', '$1', '$3').

%% NB a compiler optimising extension to the spec!?
% identifier  -> ident ':' type                   : {typed, '$1', '$3'}.

identifier  -> ident                            : list_to_atom(value_of('$1')).

rvalue      -> identifier                       : '$1'.
rvalue      -> string                           : '$1'.
rvalue      -> number                           : '$1'.
rvalue      -> list                             : '$1'.
% rvalue      -> lit_int op_and lit_int           : to_range('$1', '$2').

range_test  -> op_between number op_and number  : to_range('$2', '$4').

operator    -> op_not operator                  : {'negated', '$2'}.
operator    -> op_in                            : 'in'.
% operator    -> op_between                       : 'between'.
operator    -> op_like                          : 'like'.
operator    -> op_cmp                           : cmp_op_name(value_of('$1')).
operator    -> op_arith                         : cmp_op_name(value_of('$1')).

%% urgh - surely there's a cleaner way to define this!?
list        -> '(' list_items ')'               : '$2'.
list_items  -> string                           : [value_of('$1')].
list_items  -> string ',' list                  : [value_of('$1')|'$3'].

number      -> lit_int                          : value_of('$1').
number      -> lit_flt                          : value_of('$1').
number      -> lit_hex                          : value_of('$1').

string      -> lit_string                       : bin_value_of('$1').

Erlang code.
%% -----------------------------------------------------------------------------
%% Copyright (c) 2002-2012 Tim Watson (watson.timothy@gmail.com)
%%
%% Permission is hereby granted, free of charge, to any person obtaining a copy
%% of this software and associated documentation files (the "Software"), to deal
%% in the Software without restriction, including without limitation the rights
%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the Software is
%% furnished to do so, subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in
%% all copies or substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%% THE SOFTWARE.
%% -----------------------------------------------------------------------------
%%
%% NB: This file was generated by yecc - DO NOT MODIFY BY HAND.
%%

-export([conjunction/2, disjunction/2]).

union(Type, Lhs, Rhs) ->
    apply(?MODULE, value_of(Type), [Lhs, Rhs]).

conjunction(L, R) when is_list(R) ->
    [L|R];
conjunction(L, R) when is_list(L) ->
    L ++ [R];
conjunction(L, R) ->
    [L, R].

disjunction(L, R) ->
    {L, R}.

value_of({_,_,V}) -> V.

bin_value_of(Token) -> list_to_binary(value_of(Token)).

unary_cmp(Op, Ident) -> {Op, Ident}.

binary_cmp(Op, Lhs, Rhs) -> {Op, Lhs, Rhs}.

to_range(Low, High) -> {range, value_of(Low), value_of(High)}.

to_pattern(S) ->
    MatchOne = re:replace(S, "_{1}", "\\.\\{1\\}",
                          [global, {return, binary}]),
    MatchMany = re:replace(MatchOne, "%{1}", "\\.\\*",
                          [global, {return, binary}]),
    %% TODO: options
    %% TODO: handle compilation failure
    {ok, Rx} = re:compile(MatchMany),
    {regex, Rx}.

cmp_op_name('=')  -> eq;
cmp_op_name('<>') -> neq;
cmp_op_name('<')  -> lt;
cmp_op_name('<=') -> lteq;
cmp_op_name('>')  -> gt;
cmp_op_name('>=') -> gteq;
cmp_op_name(CmpOp) when is_atom(CmpOp) -> CmpOp.
