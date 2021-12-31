grammar calculette;

@ parser :: members
{
    HashMap<String, String> tablesSymboles = new HashMap<String, String>();
}
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
   | expression (GT | GE | LT | LE | EQ) expression
   | expression '^' expression // la puissance doit être prioritaire
   | expression '*' expression
   | expression '/' expression
   | expression '+' expression
   | expression '-' expression
   | BOOLEAN
   | IDENTIFIANT
   | ENTIER
   | FLOAT
   ;

finInstruction
   : (NEWLINE | ';')+
   ;

declaration returns[ String code ]
   : TYPE IDENTIFIANT finInstruction
   {}
   ;

instruction returns[ String code ]
   : expression finInstruction
   | 'repeter' '{' instruction* '}'
   // | 'repeter' '\n' instruction+ '\n' 'tantque' LPAREN expression RPAREN
   | 'tantque' expression
   | 'afficher' '(' IDENTIFIANT ')' finInstruction
   | 'lire' '(' IDENTIFIANT ')' finInstruction
   | assignation finInstruction
   | finInstruction {$code="";}
   ;

assignation returns[ String code ]
   : VARIABLE '=' expression
   {}
   ;
/*=========================== lexer ========================*/
   
   
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

VARIABLE
   : ('A' .. 'Z' | 'a' .. 'z') ('A' .. 'Z' | 'a' .. 'z' | '0' .. '9')*
   ;

UNMATCH
   : . -> skip
   ;

TYPE
   : 'int'
   | 'float'
   | 'bool'
   ; // pour pouvoir gérer des entiers, Booléens et floats
   
FLOAT
   : ('0' .. '9')+ '.' ('0' .. '9')* EXPONENT?
   | '.' ('0' .. '9')+ EXPONENT?
   | ('0' .. '9')+ EXPONENT
   ;

IDENTIFIANT
   : ('a' .. 'z' | 'A' .. 'Z' | '_') ('a' .. 'z' | 'A' .. 'Z' | '_' | '0' .. '9')*
   ; //à compléter
   
EXPONENT
   : ('e' | 'E') ('+' | '-')? ('0' .. '9')+
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

LPAREN
   : '('
   ;

RPAREN
   : ')'
   ;

