# Slx Jms Exchange

A front end for [SLX][slx] that parses a reasonable
subset of [JMS 1.1 Selector Expressions][jms_1_1].

The scanner and parser are both generated using the OTP [Leex][leex] and
[Yecc][yecc] libraries. The `jms_rules` module provides the semantic rule base
which [SLX][slx] uses when generating the compiler back end ([SLX][slx] is a
back end that generates compiler back ends, as it were).

Note that no *action module* is supplied with this library: in order
to produce a *useful* compiler for [JMS Selectors][jms_1_1], you will need to
combine build an action callback module. One project that demonstrates how to do
this is the [RabbitMQ JMS Selector Exchange][rmq_jms_exchange], which can be
found on GitHub [here][rmq_jms_exchange].

## Building

This code base is managed using [rebar][rebar], and you will require an up date
date version in order build the source code. Alternatively (for those who're
'setup averse') there is a wrapper makefile that will bootstrap everything you
need, provided you're running in a unix environment.

## Dependencies

Because of the way in which [SLX][slx] is designed, this project has no actual
dependencies apart from Erlang/OTP and [rebar][rebar] (if you're building from
source). You're free to make use of the scanner and lexer as two completely
independent modules if you wish.

For more details on how to use [SLX][slx] to build a simple back-end, head over
to the project's GitHub page via the links on this page.

## License

This project is distributed under the same, permissive, MIT license as
[SLX][slx].

### Links

[slx]: http://github.com/hyperthunk/slx "SLX on Github"
[jms_1_1]: http://docs.oracle.com/javaee/5/tutorial/doc/bnceh.html#bncer "JMS 1.1 Spec"
[leex]: http://www.erlang.org/doc/man/leex.html "Leex OTP Documentation"
[yecc]: http://www.erlang.org/doc/man/yecc.html "Yecc OTP Documentation"
[rmq_jms_exchange]: http://github.com/hyperthunk/rabbitmq_jms_exchange
