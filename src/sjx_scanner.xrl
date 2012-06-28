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
%% @doc this is the rule definitions file for the JMS Selector scanner.
%% -----------------------------------------------------------------------------
Definitions.
COMMA   = [,]
PARENS  = [\(\)]
L       = [A-Za-z_\$]
D       = [0-9]
F       = (\+|-)?[0-9]+\.[0-9]+((E|e)(\+|-)?[0-9]+)?
HEX     = 0x[0-9]+
WS      = ([\000-\s]|%.*)
S       = ({COMMA}|{PARENS})
CMP     = (=|>|>=|<|<=|<>)
AOP     = (\\+|-|\\*|/)

% I suspect JMS spec specific property names are less than useful
% JMS_PROP    = JMSDeliveryMode|JMSPriority|JMSMessageID|JMSTimestamp|JMSCorrelationID|JMSType

Rules.

LIKE                : {token, {op_like, TokenLine, like}}.
IN                  : {token, {op_in, TokenLine, in}}.
AND                 : {token, {op_and, TokenLine, conjunction}}.
OR                  : {token, {op_or, TokenLine, disjunction}}.
NOT                 : {token, {op_not, TokenLine, negation}}.
IS{WS}NULL          : {token, {op_null, TokenLine, is_null}}.
IS{WS}NOT{WS}NULL   : {token, {op_null, TokenLine, not_null}}.
BETWEEN             : {token, {op_between, TokenLine, range}}.
ESCAPE              : {token, {escape, TokenLine, escape}}.
{CMP}               : {token, {op_cmp, TokenLine, atomize(TokenChars)}}.
{AOP}               : {token, {op_arith, TokenLine, atomize(TokenChars)}}.
{L}({L}|{D})*       : {token, {ident, TokenLine, TokenChars}}.
'([^''])*'          : {token, {lit_string, TokenLine, strip(TokenChars,TokenLen)}}.
{S}                 : {token, {list_to_atom(TokenChars),TokenLine}}.
/\*([^\*]|\*[^/])*\*/ : skip_token.
{D}+                : {token, {lit_int, TokenLine, list_to_integer(TokenChars)}}.
{F}                 : {token, {lit_flt, TokenLine, list_to_float(TokenChars)}}.
%% do we *really* want list_to_float here?
{HEX}               : {token, {lit_hex, TokenLine, list_to_float(TokenChars)}}.
{WS}+               : skip_token.

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
%% NB: This file was generated by leex - DO NOT MODIFY BY HAND.
%%
strip(TokenChars,TokenLen) ->
    lists:sublist(TokenChars, 2, TokenLen - 2).

hex_to_int([_,_|R]) ->
    {ok,[Int],[]} = io_lib:fread("~16u", R),
    Int.

atomize(TokenChars) ->
    list_to_atom(TokenChars).