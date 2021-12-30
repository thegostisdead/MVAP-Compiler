grammar calculette;

calcul returns[ String code ] @ init
   { $code = new String(); } // On initialise $code, pour ensuite l'utiliser comme accumulateur
   @ after
   { System.out.println($code); } // on affiche le code MVaP stocké dans code
   : (decl
   { $code += $decl.code; })* NEWLINE* (instruction
   { $code += $instruction.code; })*
   { $code += " HALT\n"; }
   ;

expression
   :
   | expression '^' expression // la puissance doit être prioritaire
   | expression '*' expression
   | expression '/' expression
   | expression '+' expression
   | expression '-' expression
   | ENTIER
   | FLOAT
   ;

finInstruction
   : (NEWLINE | ';')+
   ;

decl returns[ String code ]
   : TYPE IDENTIFIANT finInstruction
   {
    // à compléter
}
   ;

instruction returns[ String code ]
   : expression finInstruction
   {
//à compléter
}
   | assignation finInstruction
   {
// à compléter
}
   | finInstruction
   {
$code="";
}
   ;

assignation returns[ String code ]
   : IDENTIFIANT '=' expression
   {
// à compléter
}
   ;
/*=========================== lexer ========================*/
   
   
NEWLINE
   : '\r'? '\n' -> skip
   ;

WS
   : (' ' | '\t')+ -> skip
   ;

ENTIER
   : ('0' .. '9')+
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
   : ('a' .. 'z' | 'A' .. 'Z' | '_') ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_')*
   ; //à compléter
   
EXPONENT
   : ('e' | 'E') ('+' | '-')? ('0' .. '9')+
   ;

