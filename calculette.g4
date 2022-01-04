grammar calculette;

@ members
{
    private TablesSymboles tablesSymboles = new TablesSymboles();
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
   | expression 'or' expression
   | expression (GT | GE | LT | LE | EQ) expression
   | expression '<>' expression // !=
   | expression '^' expression // la puissance doit être prioritaire
   | left = expression '*' right = expression
   | expression '/' expression
   { $code += " HALT\n"; }
   | left = expression '+' left = expression
   { $code += " HALT\n"; }
   | left = expression '-' right = expression
   {

       String int_regex = "[0-9]+" ;
       if ($left.text.matches(int_regex) && $right.text.matches(int_regex)) {
                $code += "SUB " + "\n";
        }

       String float_regex = "[0-9]+\\.[0-9]+";

       if ($left.text.matches(float_regex) && $right.text.matches(float_regex)) {
           $code += "SUBF " + "\n";
       }

       $code += " HALT\n";

    }
   | '-' expression // negative values
   | VARIABLE
   {
          System.out.println("PUSHG");
          AdresseType at = tablesSymboles.getAdresseType($VARIABLE.text);
          $code += "  PUSHG " + at.adresse + "\n";
   }
   | BOOLEAN
   | IDENTIFIANT
   {

       AdresseType at = tablesSymboles.getAdresseType($IDENTIFIANT.text);
       $code += "  PUSHG " + at.adresse + "\n";
   }
   | ENTIER
   {
           System.out.println("PUSHI");
           $code = "  PUSHI " + $ENTIER.text + "\n";
   }
   | FLOAT
   {
        System.out.println("PUSHF");
        $code = "  PUSHF " + $FLOAT.text + "\n";
   }
   ;

finInstruction
   : (NEWLINE | ';')+
   ;

declaration returns[ String code ]
   : TYPE VARIABLE
   {
       tablesSymboles.putVar($VARIABLE.text, $TYPE.text);

       if($TYPE.text.equals("int")) {
            $code = "PUSHI " + "0" + "\n";
       }

       if($TYPE.text.equals("float")) {
            $code = "PUSHF " + "0.0" + "\n";
       }
   }
   ;

assignation returns[ String code ]
   : VARIABLE '=' expression
   {
          AdresseType at = tablesSymboles.getAdresseType($VARIABLE.text);
          $code = $expression.code + "STOREG " + at.adresse + "\n";
   }
   ;
/* les instructions afficher / lire  */
   
   
lire returns[ String code ]
   : LIRE LPAREN expression RPAREN // a modifier expression -> identifiant
   
/* AdresseType at = tablesSymboles.getAdresseType($IDENTIFIANT.text); */

   {

           $code =  " READ \n";
           //  $code += " STOREG " + at.adresse + "\n";
   }
   ;

afficher returns[ String code ]
   : AFFICHER LPAREN expression RPAREN
   {
        $code = $expression.code;
        $code += " WRITE \n  POP\n";
   }
   ;
/* --------------------------------- */
   
   
tantque returns[ String code ]
   : TANTQUE LPAREN expression RPAREN
   ;

si returns[ String code ]
   : SI LPAREN expression RPAREN //()
   | SI LPAREN expression RPAREN LBRACE instruction+ RBRACE //Si (1+1) { test}
   
   ;

sinon returns[ String code]
   : SINON instruction
   | SINON LBRACE instruction+ RBRACE //Si (1+1) { test}
   
   ;

repeter returns[ String code ]
   : REPETER instruction+
   | REPETER LBRACE instruction+ RBRACE tantque
   ;

instruction returns[ String code ]
   : expression finInstruction
   {

      $code = $expression.code;

   }
   | repeter
   {
      $code = $repeter.code;
   }
   | tantque
   {
        $code = $tantque.code;
   }
   | si
   {
         $code = $si.code;
    }
   | sinon
   {
            $code = $sinon.code;
    }
   | afficher finInstruction
   {
        $code = $afficher.code;
   }
   | lire finInstruction
   {
       $code = $lire.code;
   }
   | declaration finInstruction
   {
      $code = $declaration.code;
  }
   | assignation finInstruction
   {
     $code = $assignation.code;
 }
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
   : 'si'
   ;

SINON
   : 'sinon'
   ;

REPETER
   : 'repeter'
   ;

FLOAT
   :('0' .. '9')+ '.' ('0' .. '9')+
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

