grammar calculette;


calcul returns[ String code ] @ init
   { $code = new String(); } // On initialise $code, pour ensuite l'utiliser comme accumulateur
   @ after
   { System.out.println($code); } // on affiche le code MVaP stocké dans code
   : (declaration
   { $code += $declaration.code; })* NEWLINE* (instruction
   { $code += $instruction.code; })*
   { $code += " HALT\n"; }
   ;

expression returns[ String code ]
   : LPAREN expression RPAREN
   | NOT expression
   | expression 'and' expression
   | expression 'or' expression
   | expression (GT | GE | LT | LE | EQ) expression
   | expression '<>' expression // !=
   | expression '^' expression // la puissance doit être prioritaire
   | expression '*' expression
   | expression '/' expression
   | expression '+' expression
   | expression '-' expression
   | '-' expression // negative values
   | VARIABLE
   | BOOLEAN
   | IDENTIFIANT
   | ENTIER
   | FLOAT
   ;

finInstruction
   : (NEWLINE | ';')+
   ;

declaration returns[ String code ]
   : TYPE VARIABLE
   ;

assignation returns[ String code ]
   : VARIABLE '=' expression
   ;
/* les instructions afficher / lire  */


lire returns[ String code ]
   : LIRE LPAREN expression RPAREN
   ;

afficher returns[ String code ]
   : AFFICHER LPAREN expression RPAREN
   ;
/* --------------------------------- */


tantque returns[ String code ]
   : TANTQUE LPAREN expression RPAREN
   ;

si returns [ String code ]
   : SI LPAREN expression RPAREN //()
   | SI LPAREN expression RPAREN LBRACE instruction+ RBRACE //Si (1+1) { test}
   ;

sinon returns [ String code]
   : SINON instruction
   | SINON LBRACE instruction+ RBRACE  //Si (1+1) { test}
   ;

repeter returns[ String code ]
   : REPETER instruction+
   | REPETER LBRACE instruction+ RBRACE tantque


   ;

instruction returns[ String code ]
   : expression finInstruction
   | repeter
   | tantque
   | si
   | sinon
   | afficher finInstruction
   | lire finInstruction
   | declaration finInstruction
   | assignation finInstruction
   | finInstruction
   {$code="";}
   ;
/*=========================== lexer ========================*/


LPAREN
   : '('
   ;

RPAREN
   : ')'
   ;

BOOLEAN
   : 'true'
   | 'false'
   ;

WS
   : (' ' | '\t' | '\r')+ -> skip
   ;

NEWLINE
   : '\n'
   ;

ENTIER
   : ('0' .. '9')+
   ;

/*
UNMATCH
   : . -> skip
   ;
*/
LIRE
   : 'lire'
   ;

AFFICHER
   : 'afficher'
   ;

TANTQUE
   : 'tantque'
   ;

SI
   :'si'
   ;

SINON
   :'sinon'
   ;

REPETER
   : 'repeter'
   ;

FLOAT
   : ('0' .. '9')+ '.'
   ;

AND
   : 'and'
   ;

OR
   : 'or'
   ;

NOT
   : 'not'
   ;

GT
   : '>'
   ;

GE
   : '>='
   ;

LT
   : '<'
   ;

LE
   : '<='
   ;

EQ
   : '=='
   ;

LBRACE
   : '{'
   ;

RBRACE
   : '}'
   ;

LBRACK
   : '['
   ;

RBRACK
   : ']'
   ;

TYPE
   : 'int'
   | 'float'
   | 'bool'
   ; // pour pouvoir gérer des entiers, Booléens et floats


VARIABLE
   : ('A' .. 'Z' | 'a' .. 'z')+ ('0' .. '9')*
   ;


IDENTIFIANT
   : ('a' .. 'z' | 'A' .. 'Z' | '_') ('a' .. 'z' | 'A' .. 'Z' | '_' | '0' .. '9')*
   ;

