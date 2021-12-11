/* Definicion Lexica */

%{
    var reserved_words = [  'int', 'double', 'boolean', 'char', 'String',
                        'print', 'println',
                        'pow', 'sqrt', 'sin', 'cos', 'tan', 'log10',
                        'caracterOfPosition', 'subString', 'length', 'toUppercase', 'toLowercase',
                        'parse',
                        'toInt', 'toDouble', 'string', 
                        'typeof',
                        'if', 'else', 
                        'switch', 'case', 
                        'break', 'continue', 'default', 
                        'do', 'while', 'for', 'in', 'begin', 'end', 
                        'struct']
    var ast_node_counter = 0;
    function getNodeNumber() { return ast_node_counter++; }
%}
%lex

%%

\s+                                             %{ /* Skip */ %}   
"//".*                                          %{ console.log(yytext); /* Skip */ %}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]             %{ console.log(yytext); /* Skip */ %}

"++"                               %{ return "++"; %} 
"--"                               %{ return "--"; %}

"+"                                %{ return "+"; %}
"-"                                %{ return "-"; %}
"*"                                %{ return "*"; %}
"/"                                %{ return "/"; %}
"%"                                %{ return "%"; %}

"=="                               %{ return "=="; %}
"!="                               %{ return "!="; %}
">="                               %{ return ">="; %}
"<="                               %{ return "<="; %}
">"                               %{ return ">"; %}
"<"                               %{ return "<"; %}

"&&"                               %{ return "&&"; %}
"||"                               %{ return "||"; %}
"!"                               %{ return "!" %}

"&"                                 %{return "&"; %}

"?"                                 %{ return "?"; %}
":"                                 %{ return ":"; %}

"="                                 %{ return "="; %}

";"                                 %{ return ";"; %}

"("                                 %{ return "("; %}
")"                                 %{ return ")"; %}
"["                                 %{ return "["; %}
"]"                                 %{ return "]"; %}
"{"                                 %{ return "{"; %}
"}"                                 %{ return "}"; %}

"."                                 %{ return "."; %}
","                                 %{ return ","; %}

(([0-9]+"."[0-9]*)|("."[0-9]+))     %{ return 'DOUBLE_LIT'; %}
[0-9]+                              %{ return 'INT_LIT'; %}

[a-zA-Z_][a-zA-Z0-9_ñÑ]*            %{ if (reserved_words.includes(yytext)) {
                                                return yytext;
                                            } else {
                                                return 'id';
                                            }
                                    %}

<<EOF>>                            %{ return "EOF"; %} 
.                                  %{ return "INVALID"; %}

/lex

%start Program

%%

Program : 
            g_dec_list EOF { 
                            var nNodes = $1.length;
                            var declarations = [];
                            for (var i = 0; i < nNodes; i++) {
                                if ($1[i].name === "LIST") {
                                    for (var j = 0; j < $1[i].children.length; j++) {
                                        declarations.push($1[i].children[j]);
                                    }
                                } else if ($1[i].name === "FUN_DEC") { 
                                    declarations.push($1[i]);
                                }
                            }
                            program = new QNode("PROGRAM", { label: 'program' }, 0, 0, declarations); 
                            return program; }
;

g_dec_list : 
            g_dec_list g_dec { $1.push($2); $$ = $1; }
            | g_dec { $$ = [$1]}
;

g_dec :
                        var_dec_list ';' { $$ = $1; }
                        | fun_dec { $$ = $1; }
                        | struct_dec { }
;

var_dec_list : 
            type_specifier id_list { 
                var ids = $2.length;
                var vars = [];
                for (var i = 0; i < ids; i++) {
                    var current_node = $2[i];
                    var new_node = undefined;
                    if ('init_expr' in current_node.attrs) {
                        new_node = new QNode("VAR_DEC", { label: 'Variable Declaration' }, current_node.line, current_node.col, [current_node, $1, current_node.attrs['init_expr']]);
                    } else {
                        new_node = new QNode("VAR_DEC", { label: 'Variable Declaration' }, current_node.line, current_node.col, [current_node, $1]);
                    }
                    vars.push(new_node);
                }
                var listNode = new QNode("LIST", { label: 'LIST'}, 0, 0, vars);
                $$ = listNode;
            }
        |   type_specifier '[' ']' id_list { 
                var ids = $4.length;
                var vars = [];
                for (var i = 0; i < ids; i++) {
                    var current_node = $4[i];
                    var new_node = undefined;
                    if ('init_expr' in current_node.attrs) {
                        new_node = new QNode("VAR_DEC", { label: '[Variable Declaration]', is_array: true }, current_node.line, current_node.col, [current_node, $1, current_node.attrs['init_expr']]);
                    } else {
                        new_node = new QNode("VAR_DEC", { label: '[Variable Declaration]', is_array: true }, current_node.line, current_node.col, [current_node, $1]);
                    }
                    vars.push(new_node);
                }
                var listNode = new QNode("LIST", { label: 'LIST'}, 0, 0, vars);
                $$ = listNode;
            }
;


type_specifier :
                    'int'           { $$ = new QNode("int", { label: 'int' }, @1.first_line, @1.first_column, null); }
                    | 'double'      { $$ = new QNode("double", { label: 'double' }, @1.first_line, @1.first_column, null); }
                    | 'boolean'     { $$ = new QNode("boolean", { label: 'boolean' }, @1.first_line, @1.first_column, null); }
                    | 'char'        { $$ = new QNode("char", { label: 'char' }, @1.first_line, @1.first_column, null); }
                    | 'String'      { $$ = new QNode("String", { label: 'String' }, @1.first_line, @1.first_column, null); }
                    | id            { $$ = new QNode("ID", {label: String($1)}, @1.first_line, @1.first_column, null); }
;

id_list :
                    id_list ',' id_init { $1.push($3); $$ = $1; }
                    | id_init           { $$ = [$1]; }
;

id_init :
                    id '=' expr { $$ = new QNode("ID", { id_name : String($1), init_expr : $3 , label: String($1) }, @1.first_line, @1.first_column, null); }
                    | id        { $$ = new QNode("ID", { id_name : String($1), label: String($1) }, @1.first_line, @1.first_column, null); }
;

fun_dec : 
            type_specifier id '(' formal_params ')' '{' stmts '}' {{ 
                // Paramer list node 
                var numberOfParameters = $4.length;
                var parameterList = [ ];
                for (var i = 0; i < numberOfParameters; i++) {
                    parameterList.push($4[i]);
                }
                // the id node
                var idNode = new QNode("ID", {label: String($2)}, @2.first_line, @2.first_column, null)
                var parametersNode = new QNode("PARAMETERS", { label: "Parameter List"}, 0, 0, parameterList);
                // Block node
                var numberOfStmts = $7.length;
                var stmtList = [ ];
                for (var j = 0; j < numberOfStmts; j++) {
                    stmtList.push($7[j]);
                }
                var blockNode = new QNode("BLOCK", { label: "bloque"}, $6.first_line, $6.first_column, stmtList);
                // The function node
                var funcNode = new QNode("FUN_DEC", { label: "Function Declaration" }, @2.first_line, @2.first_column, [$1, idNode, parametersNode, blockNode]);
                $$ = funcNode;  
            }}
        | type_specifier id '(' ')' '{' stmts '}' {{ 
                // the id node
                var idNode = new QNode("ID", {label: String($2)}, @2.first_line, @2.first_column, null)
                var parametersNode = new QNode("PARAMETERS", { label: "Parameter List"}, 0, 0, null);
                // Block node
                var numberOfStmts = $6.length;
                var stmtList = [ ];
                for (var j = 0; j < numberOfStmts; j++) {
                    stmtList.push($6[j]);
                }
                var blockNode = new QNode("BLOCK", { label: "bloque"}, $6.first_line, $6.first_column, stmtList);
                // The function node
                var funcNode = new QNode("FUN_DEC", { label: "Function Declaration" }, @2.first_line, @2.first_column, [$1, idNode, parametersNode, blockNode]);
                $$ = funcNode;
            }}
;

formal_params: 
                formal_params ',' formal_param { $1.push($3); $$ = $1; }
                | formal_param { $$ = [$1]; }
;

formal_param:
                type_specifier id {
                                    $$ = new QNode("PARAMETER", {label: "parameter"}, @2.first_line, @2.first_column, [$1, new QNode("ID", {label: String($2)}, @2.first_line, @2.first_column, null)])}
;

stmts: 
            stmts stmt { $1.push($2); $$ = $1; }
            | stmt { $$ = [$1]; }
;

stmt:   
            'print' '(' exprs ')' ';' { $$ = new QNode("PRINT", { label: "print" }, @1.first_line, @1.first_col, $3); }
            | ';'                     { $$ = new QNode("NoOP", { label: "No Statement"}, @1.first_line, @1.first_column, null); } // Empty statment? 
;

exprs : 
        exprs ',' expr { $1.push($3); $$ = $1; }
        | expr         { $$ = [$1]; }
;

expr :
        | DOUBLE_LIT    { $$ = new QNode("DOUBLE", { literal : Number($1), label: String($1) }, @1.first_line, @1.first_column, null); }
        | INT_LIT       { $$ = new QNode("INT", { literal: Number($1) , label: String($1) }, @1.first_line, @1.first_column, null);}
;

