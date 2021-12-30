lexer grammar calculette;

calcul returns[ String code ] @ init
   { $code = new String(); } // On initialise $code, pour ensuite l'utiliser comme accumulateur
   @ after
   { System.out.println($code); } // on affiche le code MVaP stocké dans code
   : (decl
   { $code += $decl.code; })* NEWLINE* (instruction
   { $code += $instruction.code; })*
   { $code += " HALT\n"; }
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
   // lexer
   
TYPE
   : 'int'
   | 'float'
   | 'bool'
   ; // pour pouvoir gérer des entiers, Booléens et floats
   
IDENTIFIANT
   :
   ; //à compléter
   
