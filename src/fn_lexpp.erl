-module(fn_lexpp).
-export([clean_whites/1, indent_to_blocks/1]).

-license("New BSD License, part of efene, see LICENSE for details").

% lex post procesor, modifies the lex generated by fn_lexer.erl to make it
% suitable for fn_parser.yrl

pre_cleanup(Tokens) ->
    pre_cleanup(Tokens, []).

pre_cleanup([], Accum)->
    lists:reverse(Accum);
% remove new lines after a comma so we can have statements in multiple lines
pre_cleanup([{sep, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{add_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{add_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{mul_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{mul_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{and_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{and_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{or_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{or_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{shift_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{shift_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{bool_andalso_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{bool_andalso_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{bool_and_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{bool_and_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{bool_orelse_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{bool_orelse_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{bool_or_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{bool_or_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{bool_comp_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{bool_comp_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{concat_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{concat_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{arrow, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{arrow, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{fatarrow, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{fatarrow, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{split_op, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{split_op, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{open_block, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{open_block, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{open_list, _, _}=Token, {endl, _, _}, {white, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);
pre_cleanup([{open_list, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|Accum]);

pre_cleanup([{else, _}=Else, {endl, _, _}, {white, _, _}, {'if', _}=Token|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|[Else|Accum]]);
pre_cleanup([{else, _}=Else, {endl, _, _}, {'if', _}=Token|Tokens], Accum) ->
    pre_cleanup(Tokens, [Token|[Else|Accum]]);

pre_cleanup([Head|Tokens], Accum) ->
    pre_cleanup(Tokens, [Head|Accum]).

% post_cleanup eliminates the newlines before tokens like else, fn, etc so they
% are easier to parse (all end like "} token" instead of "} \n token")
post_cleanup([{endl, _, _}|Tokens]) -> % remove the first newline
    post_cleanup(Tokens, []);
post_cleanup(Tokens) ->
    post_cleanup(Tokens, []).
post_cleanup([], Accum)->
    lists:reverse(Accum);

post_cleanup([{endl, _, _}, {fn, _}=Token|Tokens], Accum) ->
    post_cleanup(Tokens, [Token|Accum]);
post_cleanup([{endl, _, _}, {else, _}=Token|Tokens], Accum) ->
    post_cleanup(Tokens, [Token|Accum]);
post_cleanup([{endl, _, _}, {'catch', _}=Token|Tokens], Accum) ->
    post_cleanup(Tokens, [Token|Accum]);
post_cleanup([{endl, _, _}, {'after', _}=Token|Tokens], Accum) ->
    post_cleanup(Tokens, [Token|Accum]);
% remove the new lines after a opening block, makes parsing easier
post_cleanup([{open_block, _, _}=Token, {endl, _, _}|Tokens], Accum) ->
    post_cleanup(Tokens, [Token|Accum]);
% don't remove endlines before an open block that is part of a struct
% definition. This may create syntax errors if the if the previout tokens were
% } \n { since it will join the closing and opening blocks
post_cleanup([{endl, _, _}=Endl, {open_block, _, _}=Token, Something, {split_op, _, _}=Split|Tokens], Accum) ->
    post_cleanup(Tokens, [Split|[Something|[Token|[Endl|Accum]]]]);
% remove endlines before opening blocks, reinsert in tokens to process
% patterns of openblock and endlines after it
post_cleanup([{endl, _, _}, {open_block, _, _}=Token|Tokens], Accum) ->
    post_cleanup([Token|Tokens], Accum);
% remove endlines before |]
post_cleanup([{close_block, _, _}=Close, {endl, _, _}, {close_oxford, _, _}=Token|Tokens], Accum) ->
    post_cleanup(Tokens, [Token|[Close|Accum]]);
post_cleanup([{close_block, _, _}=Close, {endl, _, _}, {'case', _}=Token|Tokens], Accum) ->
    post_cleanup(Tokens, [Token|[Close|Accum]]);
% remove endline between } and , to allow defining lambdas as parameters
post_cleanup([{close_block, _, _}=Close, {endl, _, _}, {sep, _, _}=Token|Tokens], Accum) ->
    post_cleanup(Tokens, [Token|[Close|Accum]]);
post_cleanup([Head|Tokens], Accum) ->
    post_cleanup(Tokens, [Head|Accum]).

clean_whites(Tokens) ->
    clean_whites(pre_cleanup(Tokens), []).

clean_whites([], Accum)->
    post_cleanup(lists:reverse(Accum));
clean_whites([Head|Tokens], Accum) when element(1, Head) == white ->
    clean_whites(Tokens, Accum);
clean_whites([Head|Tokens], Accum) when element(1, Head) == tab ->
    clean_whites(Tokens, Accum);
clean_whites([Head|Tokens], Accum) ->
    clean_whites(Tokens, [Head|Accum]).

indent_to_blocks(Tokens) ->
    indent_to_blocks(pre_cleanup(Tokens), [], []).

indent_to_blocks([]=_Tokens, []=_Indents, Accum) ->
    post_cleanup(lists:reverse(Accum));

% no more tokens but still indents remaining to be closed
indent_to_blocks([]=Tokens, [_Indent|Indents], Accum) ->
    indent_to_blocks(Tokens, Indents, [{close_block, 0, '}'}|[{endl, 0, 1}|Accum]]);

% indent, and there is no current indentation
indent_to_blocks([{endl, Line, _}=Endl, {white, _, NewIndent}|Tokens], []=_Indents, Accum) ->
    indent_to_blocks(Tokens, [NewIndent], [endl(Endl)|[{open_block, Line, '{'}|Accum]]);

% indent > than the current one
indent_to_blocks([{endl, Line, _}=Endl, {white, _, NewIndent}|Tokens], [Indent|_]=Indents, Accum)
        when NewIndent > Indent ->
    indent_to_blocks(Tokens, [NewIndent|Indents], [endl(Endl)|[{open_block, Line, '{'}|Accum]]);

% indent < than the current one
indent_to_blocks([{endl, Line, _}=Endl, {white, _, NewIndent}|_]=Tokens, [Indent|Indents], Accum)
        when NewIndent < Indent ->
    indent_to_blocks(Tokens, Indents, [{close_block, Line, '}'}|[endl(Endl)|Accum]]);

% indent = than the current one
indent_to_blocks([{endl, _, _}=Endl, {white, _, NewIndent}|Tokens], [Indent|_]=Indents, Accum)
        when NewIndent == Indent ->
    indent_to_blocks(Tokens, Indents, [endl(Endl)|Accum]);

% new line without whitespace, indents available and the last token is a new
% line (avoid adding two newlines while closing blocks
indent_to_blocks([{endl, Line, _}=Endl|_]=Tokens, [_Indent|Indents], [{endl, _, _}|_]=Accum) ->
    indent_to_blocks(Tokens, Indents, [endl(Endl)|[{close_block, Line, '}'}|Accum]]);

% new line without whitespace and indents available
indent_to_blocks([{endl, Line, _}=Endl|_]=Tokens, [_Indent|Indents], Accum) ->
    indent_to_blocks(Tokens, Indents, [endl(Endl)|[{close_block, Line, '}'}|[endl(Endl)|Accum]]]);

% new line without whitespace and no indents available, last is a new line
% don't insert the new line, avoid duplicated new lines
indent_to_blocks([{endl, _, _}=Endl|Tokens], []=Indents, [{endl, _, _}|Accum]) ->
    indent_to_blocks(Tokens, Indents, [endl(Endl)|Accum]);

% new line without whitespace and no indents available
% insert the new line, needed for example in record definitions
indent_to_blocks([{endl, _, _}=Endl|Tokens], []=Indents, Accum) ->
    indent_to_blocks(Tokens, Indents, [endl(Endl)|Accum]);

% remove whites that reach this clause
indent_to_blocks([{white, _, _}|Tokens], Indents, Accum) ->
    indent_to_blocks(Tokens, Indents, Accum);

indent_to_blocks([Token|Tokens], Indents, Accum) ->
    indent_to_blocks(Tokens, Indents, [Token|Accum]).

endl({endl, Line, _}) ->  {endl, Line, "\n"}.
