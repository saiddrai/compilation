%{
	int nb_ligne=1;
	int nb_colonne=1;
	char sauvType[25];
	int taille;
  float i,p;
%}

%union 
{ 
   int entier; 
   char* str;
   float reel;

};

%token vrg mc_idf mc_div mc_prog mc_id mc_data mc_work mc_storage mc_section mc_proc mc_stop mc_run err_lex
%token mc_int mc_char mc_float mc_str mc_const mc_and mc_or mc_not mc_line mc_size
%token mc_accept mc_display mc_if mc_else mc_end mc_move mc_to hash dol pourc an aro Dpoint
%token moin plus slash egl cote mul pipe pa_ouv pa_fer point l g ge le eq di
%token <str>idf <str>cst_char <entier>cst_int <reel>cst_reel <str>cst_str msgdispacc msgdisp 
%start S

%%
S: mc_idf mc_div point mc_prog moin mc_id point idf point mc_data mc_div point mc_work moin mc_storage mc_section point P_DEC mc_proc mc_div point P_INST mc_stop mc_run point{ printf ("syntaxe correcte /n /n");
						YYACCEPT;
						}
						;
P_DEC: P_DEC_VAR P_DEC 				
		  | P_DEC_CONST P_DEC 
		  | P_DEC_TAB P_DEC  
		  |;



		  
P_DEC_TAB: LIST_IDF mc_line cst_int vrg mc_size cst_int TYPE point /* {								 Tab | M LINE 0 , SIZE 8 INTEGER . 
													if(doubleDeclaration($1)==0)
                                     			      insererTypeIDF($1,sauvType);
													else printf("\n \n Erreur semantique: double declaration  de %s a la ligne %d\n",$1,nb_ligne);   
													if ($3 > $6)
													printf("\n \n Erreur semantique: size doit etre supérieure à line a la ligne %d",nb_ligne);
													if (($3 <= 0) ||  ($6 <= 0))   
													 printf("\n \n Erreur semantique:la taille de tableau %s doit etre positive et !=0 a la ligne  %d\n",$1,nb_ligne);
													 else {
														taille= $3*$6; 
													   appeli insererTaille($1, taille) ma3reftch njib issem l'idf
													  	}
																	}   
																	*/
;

P_DEC_VAR: LIST_IDF TYPE point;  					 										/*A | Bc INTEGER. */ 
			  
P_DEC_CONST: mc_const idf TYPE point P_DEC_CONST      								    	  /*CONST B FLOAT.*/
			    | mc_const idf egl CST point P_DEC_CONST |;			
				
TYPE : mc_char   {strcpy(sauvType,"CHAR");}
	  |mc_int    {strcpy(sauvType,"INT");}
      |mc_str	 {strcpy(sauvType,"STRING");}
      |mc_float  {strcpy(sauvType,"FLOAT");} ;


LIST_IDF : idf pipe LIST_IDF {
									 if(doubleDeclaration($1)==0)
                                     insererTypeIDF($1,sauvType);
							    else
								printf("\n \n Erreur semantique: double declaration  de %s a la ligne %d\n",$1,nb_ligne);
								}
			| idf {
				if(doubleDeclaration($1)==0)
                                     insererTypeIDF($1,sauvType);
							    else
								printf("\n \n Erreur semantique: double declaration  de %s a la ligne %d\n",$1,nb_ligne);
			} ;    

CST : cst_char|cst_str | CST_NUM;
CST_NUM : cst_int | cst_reel;

/* lazem ndirou tany les ki nkhdmou b idf bla mandiclariwh */


P_INST :   ENT_SORT P_INST
			| CONDITION_IF P_INST
			| MOVE P_INST
			| EXPR_ARITH P_INST
			|;
			
ENT_SORT: SORT | ENT;
SORT: mc_display pa_ouv msgdispacc Dpoint idf pa_fer point		/* DISPLAY (“psps $”: hh ).*/
	 |mc_display pa_ouv msgdisp pa_fer point;					 /*DISPLAY (“hello brother”). */
ENT: mc_accept pa_ouv msgdispacc Dpoint aro idf pa_fer point;    /* ACCEPT (“#”:@ C ). */




 /* CONDITION_IF: mc_if pa_ouv CONDITION pa_fer Dpoint P_INST ELSE mc_end point;
ELSE: mc_else Dpoint P_INST  
	  | ;

			
COMPARAISON: EXPRESSION2 EXP_COMPA EXPRESSION2;
CONDITION:COMPARAISON 
		| CONDITION EXP_LOG CONDITION 
		| COMPARAISON EXP_LOG COMPARAISON 
		| CONDITION EXP_LOG COMPARAISON 
		| COMPARAISON EXP_LOG CONDITION;


EXP_LOG :mc_and | mc_or ;
EXP_COMPA: l | g | ge | le | eq | di ;
*/

CONDITION_IF: mc_if pa_ouv CONDITION pa_fer Dpoint P_INST ELSE mc_end point;
ELSE: mc_else Dpoint P_INST  
	  | ;



CONDITION :  pa_ouv EXPRESSION2 EXP_COMPA EXPRESSION2 pa_fer EXP_LOG CONDITION
			|mc_not EXPRESSION2 pa_fer EXP_LOG CONDITION
			|pa_ouv EXPRESSION2 EXP_COMPA EXPRESSION2 pa_fer
			| mc_not CONDITION ;
			
EXPRESSION1: CST_NUM | idf ;
EXPRESSION2: EXPRESSION1 | CALCUL ;
EXP_LOG :mc_and | mc_or ;
EXP_COMPA: l | g | ge | le | eq | di ;

MOVE: mc_move idf mc_to idf P_INST mc_end point {			 				   /* MOVE A TO M P_inst END.  , MOVE A TO 10 P_inst END. */
												i=rechercherVal($2);
												p=rechercherVal($4);
												if (p<i)
												{printf("\n \n Erreur semantique: la 1er parametre de move supperieur a la 2eme.  a la ligne %d\n",nb_ligne);}
												}
	  |mc_move idf mc_to cst_int P_INST mc_end point {			 				   /* MOVE A TO M P_inst END.  , MOVE A TO 10 P_inst END. */
												i=rechercherVal($2);												
												if ($4<i)
												{printf("\n \n Erreur semantique: la 1er parametre de move supperieur a la 2eme. a la ligne %d\n",nb_ligne);}
												}											
	  |mc_move cst_int mc_to cst_int P_INST mc_end point {			 /* MOVE 1 TO 3 P_inst END. */
												if ($4<$2)
												{printf("\n \n Erreur semantique: la 1er parametre de move supperieur a la 2eme.  a la ligne %d\n",nb_ligne);}
															};



EXPR_ARITH:idf egl CALCUL point;
CALCUL: pa_ouv EXPRESSION1 OPERATEUR EXPRESSION1 pa_fer OPERATEUR CALCUL
		| pa_ouv EXPRESSION1 OPERATEUR EXPRESSION1 pa_fer
		|EXPRESSION1;
OPERATEUR : mul | plus | moin | slash ;


/*
EXPRESSION1: CST_NUM | idf ;
EXPRESSION2: EXPRESSION1 | CALCUL ;



EXPR_ARITH:idf egl CALCUL point;                      									  

OPERATEUR : mul | plus | moin | slash ;





CALCUL: pa_ouv EXPRESSION2 OPERATEUR EXPRESSION2 pa_fer 
		|EXPRESSION1;
*/	





%%
int yyerror(char*msg)
{
	printf("erreur syntaxique a la ligne : %d  et la colonne : %d ",nb_ligne,nb_colonne);
	return 1;
}
main()
{
	initialisation();
	yyparse();
	afficher();
}
yywrap()
{}