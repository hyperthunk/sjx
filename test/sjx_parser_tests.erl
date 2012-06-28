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
-module(sjx_parser_tests).
-include_lib("eunit/include/eunit.hrl").
-include_lib("hamcrest/include/hamcrest.hrl").

-import(sjx_dialect, [analyze/1]).

basic_spec_test_() ->
    [?_assertThat(analyze("JMSType = 'car'"),
                  is(equal_to([{eq, 'JMSType', <<"car">>}]))),

     ?_assertThat(analyze("colour = 'blue'"),
                  is(equal_to([{eq, 'colour', <<"blue">>}]))),

     ?_assertThat(analyze("weight > 2500"),
                  is(equal_to([{gt, 'weight', 2500}]))),

     ?_assertThat(
            analyze("JMSType = 'car' AND colour = 'blue' AND weight > 2500"),
                  has_same_contents_as([{eq, 'JMSType', <<"car">>},
                                        {eq, 'colour', <<"blue">>},
                                        {gt, 'weight', 2500}])),

     ?_assertMatch(
            {{eq, 'JMSType', <<"car">>}, [
                    {eq, 'colour', <<"blue">>},
                    {gt, 'weight', 2500}]},
            analyze("JMSType = 'car' OR colour = 'blue' AND weight > 2500"))].
