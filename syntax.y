%{
	int nb_ligne=1;
	int nb_colonne=1;
	int i=0;	
	int j;
	
	char sauvType[25];
	char save[20];
	char saveCst[20];
	char IDF[100][20];
	char IDFF[20];

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
S: mc_idf mc_div point mc_prog moin mc_id point idf{i=0;} point mc_data mc_div point mc_work moin mc_storage mc_section point P_DEC mc_proc mc_div point P_INST mc_stop mc_run point{ printf ("Syntaxe correcte /n /n");
						YYACCEPT;
						};
P_DEC: P_DEC_VAR P_DEC 				
		| P_DEC_CONST P_DEC 
		| P_DEC_TAB P_DEC  
		|;



		  
P_DEC_TAB: LIST_IDF mc_line cst_int vrg mc_size cst_int TYPE point { strcpy(sauvType,save);	
																	for (j=0; j<i; j++)
																	{ if(doubleDeclaration(IDF[j])==0)	
																		{insererTypeIDF(IDF[j] , sauvType );
																		 DonnerVS(IDF[j] ,1);
																		 }
																	   else { if(doubleDeclaration(IDF[j])==-1)
																		{printf("\n ==============> Erreur Semantique Double declaration a la ligne %d <==============\n",nb_ligne);
																		return -1;}
																	  }
																	}

																    Re_TAB(IDF,i);	i=0;
																	if (($6<$3) || ($6<0))
																	{printf("\n ==============> Erreur Semantique fausse taille  a la ligne %d <==============\n",nb_ligne);
																	return -1;}
																		
																	   };


/*______________________________________________________________________________________________________*/


P_DEC_VAR: LIST_IDF TYPE point {  for (j=0; j<i; j++)
								   { if(doubleDeclaration(IDF[j])==0)	
								   	{
										insererTypeIDF(IDF[j] , save);
								   		DonnerVS(IDF[j] ,1);
									}
								      	else{
											 if(doubleDeclaration(IDF[j])==-1)
								   				{
										   		printf("tsama haka hab y9ol hna lghlta psk     %d     ",i);
										   		printf("\n ==============> Erreur Semantique Double declaration a la ligne %d <==============\n",nb_ligne);
								   				return -1;
												}
								     		}

								   }
								   	Re_TAB(IDF,i); i=0;
								   	};  					 
/*__________________________________________________________________________________________________________________________*/

P_DEC_CONST: mc_const idf TYPE point {for (j=0; j<i; j++)
										{ if(doubleDeclaration(IDF[j])==0)	
											{insererTypeIDF(IDF[j] , save );
											 DonnerVS(IDF[j] ,0);}
										   else { if(doubleDeclaration(IDF[j])==-1)
											{printf("\n ==============> Erreur Semantique Double declaration a la ligne %d <==============\n",nb_ligne);
											return -1;}
										  }
										}
											Re_TAB(IDF,i);i=0;
	
												}

			    | mc_const idf egl CST point P_DEC_CONST {Re_TAB(IDF,i);i=0;}
				|{Re_TAB(IDF,i);i=0;}
				;			
/*__________________________________________________________________________________________________________________________*/
				
TYPE : mc_int    {strcpy(save,"INT");}
	  |mc_float  {strcpy(save,"FLOAT");}
      |mc_char	 {strcpy(save,"CHAR");}
      |mc_str    {strcpy(save,"STRING");} ;


/*__________________________________________________________________________________________________________________________*/

LIST_IDF : idf pipe LIST_IDF {  strcpy(IDFF , $1);  strcpy(IDF[i] , IDFF);  i++;  }
		 | idf { strcpy(IDFF , $1);  strcpy(IDF[i], IDFF);  i++;  }
		 ;
/*__________________________________________________________________________________________________________________________*/

CST : cst_char|cst_str | CST_NUM;
/*__________________________________________________________________________________________________________________________*/

CST_NUM : cst_int | cst_reel;

/*__________________________________________________________________________________________________________________________*/

P_INST : ENTR_OR_SORT P_INST
		|CONDITION_IF P_INST
		|MOVE P_INST
		|EXPR_ARITH P_INST
		|;

/*__________________________________________________________________________________________________________________________*/
			
ENTR_OR_SORT: ENTR | SORT ;

ENTR: mc_accept pa_ouv msgdispacc Dpoint aro idf pa_fer point;    /* ACCEPT (“#”:@ C ). */

/*__________________________________________________________________________________________________________________________*/

SORT: mc_display pa_ouv msgdispacc Dpoint IDF_sort pa_fer point		/* DISPLAY (“psps $”: hh ).*/
	 |mc_display pa_ouv msgdisp pa_fer point;						 /*DISPLAY (“hello brother”). */


/*__________________________________________________________________________________________________________________________*/

IDF_sort : idf vrg IDF_sort							
		 | idf;  			
							
/*__________________________________________________________________________________________________________________________*/

CONDITION_IF: mc_if pa_ouv CONDITION pa_fer Dpoint P_INST ELSE mc_end point;
/*__________________________________________________________________________________________________________________________*/

ELSE: mc_else Dpoint P_INST {printf("====================================================")};
/*__________________________________________________________________________________________________________________________*/

CONDITION :  pa_ouv EXPRESSION EXP_COMPA EXPRESSION pa_fer EXP_LOG CONDITION
			|pa_ouv EXPRESSION EXP_COMPA EXPRESSION pa_fer
			|mc_not EXPRESSION pa_fer EXP_LOG CONDITION
			|mc_not CONDITION ;
/*__________________________________________________________________________________________________________________________*/
EXPRESSION: EX1 
		   |CALCUL;

/*__________________________________________________________________________________________________________________________*/

EX1: CST_NUM | idf;
/*__________________________________________________________________________________________________________________________*/

EXP_LOG :mc_and | mc_or ;
/*__________________________________________________________________________________________________________________________*/

EXP_COMPA: l | g | ge | le | eq | di ;
/*__________________________________________________________________________________________________________________________*/


MOVE: mc_move A mc_to A P_INST mc_end point ;			 				   /* MOVE A TO M P_inst END.  , MOVE A TO 10 P_inst END. */
												

/*__________________________________________________________________________________________________________________________*/
A: 	idf
	|cst_int
;	
/*__________________________________________________________________________________________________________________________*/

EXPR_ARITH:idf egl CALCUL point  {
										printf("\n ==============> Erreur Semantique idf non declaré a la ligne %d <==============\n",nb_ligne);
									}
		   |idf egl CST point
		   |idf egl idf point;
/*__________________________________________________________________________________________________________________________*/

CALCUL: idf OPERATEUR idf { 
										printf("\n ==============> Erreur Semantique idf non declaré a la ligne %d <==============\n",nb_ligne);
									}
		| idf OPERATEUR CST_NUM
		| CST_NUM OPERATEUR CST_NUM
		| CST_NUM OPERATEUR idf 
		| idf OPERATEUR CALCUL	   
		| CALCUL OPERATEUR idf	   
		| CST_NUM OPERATEUR CALCUL 
		| CALCUL  OPERATEUR CST_NUM
		| pa_ouv CALCUL pa_fer	   
		| CALCUL OPERATEUR CALCUL  
;
/*__________________________________________________________________________________________________________________________*/

OPERATEUR : mul | plus | moin | slash ;
		 /*___________________________________________________________________________________________________________________*/
				/*_______________________________________________________________________________________________________*/
					/*___________________________________________________________________________________________*/
	 						 /*____________________________________________________________________________*/
										/*________________________________________________*/

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