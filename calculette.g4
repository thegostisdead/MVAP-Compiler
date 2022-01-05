grammar calculette;

@members
{
   private TablesSymboles tablesSymboles = new TablesSymboles();

   private int _cur_label = 1;
   private String getNewLabel() 
   {
    return "B" +(_cur_label++); 
   }

   private boolean testInt(String var)
   {
      String int_regex = "[0-9]+";
      return var.matches(int_regex);
   }

   private boolean testFloat(String var)
   {
      String float_regex = "[0-9]+\\.[0-9]+";
      return var.matches(float_regex);
   }
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
   | expression op=(GT | GE | LT | LE | EQ) expression
   {
      if ($op.text.equals(">"))
      {
         $code = "SUP";
      }

      if ($op.text.equals(">="))
      {
         $code = "SUPEQ";
      }

      if ($op.text.equals("<"))
      {
         $code = "INF";
      }

      if ($op.text.equals("<="))
      {
         $code = "INFEQ";
      }

      if ($op.text.equals("=="))
      {
         $code = "EQUAL";
      }
   }
   | expression '<>' expression // !=
   | expression '^' expression // la puissance doit être prioritaire
   | left = expression '*' right = expression
   {

      if (testInt($left.text) && testInt($right.text))
      {
         $code = "MUL" + "\n";
      }



      if (testFloat($left.text) && testFloat($right.text))
      {
         $code = "FMUL" + "\n";
      }

      $code = " HALT\n";
   }
   | left = expression '/' right = expression
   { 
      if(testInt($left.text) && testInt($right.text))
      {
         $code = "DIV" + "\n";
      }



      if (testFloat($left.text) && testFloat($right.text))
      {
         $code = "FDIV" + "\n";
      }

      $code = " HALT\n";
   }
   | left = expression '+' right = expression
   { 
      if (testInt($left.text) && testInt($right.text))
      {
         $code = "ADD" + "\n";
      }



      if (testFloat($left.text) && testFloat($right.text))
      {
         $code = "FADD" + "\n";
      }

      $code = " HALT\n";
   }
   | left = expression '-' right = expression
   {

      if (testInt($left.text) && testInt($right.text))
      {
         $code = "SUB" + "\n";
      }



      if (testFloat($left.text) && testFloat($right.text))
      {
         $code = "FSUB" + "\n";
      }

      $code = " HALT\n";

   }

   | VARIABLE
   {
          AdresseType at = tablesSymboles.getAdresseType($VARIABLE.text);
          $code = "PUSHG" + at.adresse + "\n";
   }
   | BOOLEAN
   {
      if($BOOLEAN.text.equals("true"))
      {
         $code = "PUSHI 1 \n";
      }

      if($BOOLEAN.text.equals("false"))
      {
         $code = "PUSHI 0 \n";
      }
      
   }
   | IDENTIFIANT
   {

      AdresseType at = tablesSymboles.getAdresseType($IDENTIFIANT.text);
      $code = "PUSHG" + at.adresse + "\n";
   }
   | ENTIER
   {
      $code = "PUSHI" + $ENTIER.text + "\n";
   }
   | '-' ENTIER
   {
      $code = "PUSHI -" + $ENTIER.text + "\n"; //Negative int
   }
   | FLOAT
   {
      $code = "PUSHF" + $FLOAT.text + "\n";
   }
   | '-' FLOAT
   {
      $code = "PUSHF -" + $FLOAT.text + "\n"; //Negative float
   }
   ;

finInstruction returns[ String code ]
   : (NEWLINE | ';')+
   {

      $code = "Fin d'instruction \n";
   }
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
   : LIRE LPAREN expression RPAREN  // a modifier expression -> identifiant
   
/* AdresseType at = tablesSymboles.getAdresseType($IDENTIFIANT.text); */

   {

           $code =  "READ \n";
           //  $code += " STOREG " + at.adresse + "\n";
   }
   ;

afficher returns[ String code ]
   : AFFICHER LPAREN expression RPAREN
   {
        $code = $expression.code;
        $code += "WRITE \n  POP\n";
   }
   ;
/* --------------------------------- */
   
   
tantque returns[ String code ]
   : TANTQUE LPAREN expression RPAREN (LBRACE instruction+ RBRACE)*
   {
       String boucleIn = getNewLabel();
        String boucleOut = getNewLabel();
        $code = "LABEL " + boucleIn +"\n";
        $code += $expression.code;
        $code += "JUMPF " + boucleOut + "\n";
        $code += $instruction.code;
        $code += "JUMP " + boucleIn+"\n";
        $code += "LABEL " + boucleOut + "\n";

   }
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
   {
      $code = $finInstruction.code;
   }
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

