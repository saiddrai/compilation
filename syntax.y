%{
	int nb_ligne=1;
	int nb_colonne=1;
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
S: mc_idf mc_div point mc_prog moin mc_id point idf point mc_data mc_div point mc_work moin mc_storage mc_section point P_DEC mc_proc mc_div point P_INST mc_stop mc_run point{ printf ("syntaxe correcte \n \n");
						YYACCEPT;
						}
						;
P_DEC: P_DEC_VAR P_DEC 
		  | P_DEC_CONST P_DEC 
		  | P_DEC_TAB P_DEC
		  |;
		  
P_DEC_TAB: LIST_IDF mc_line cst_int vrg mc_size cst_int TYPE point; 

P_DEC_VAR: LIST_IDF TYPE point;
			  
P_DEC_CONST: mc_const idf TYPE point P_DEC_CONST 
			    | mc_const idf egl CST point P_DEC_CONST |;
				
TYPE : mc_char|mc_int|mc_str|mc_float;

LIST_IDF : idf pipe LIST_IDF | idf ;

CST : cst_char|cst_str | CST_NUM;
CST_NUM : cst_int | cst_reel;

P_INST :   ENT_SORT P_INST
			| CONDITION_IF P_INST
			| MOVE P_INST
			| EXPR_ARITH P_INST
			|;
			
ENT_SORT: SORT | ENT;
SORT: mc_display pa_ouv msgdispacc Dpoint idf pa_fer point
	 |mc_display pa_ouv msgdisp pa_fer point;
ENT: mc_accept pa_ouv msgdispacc Dpoint aro idf pa_fer point;


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


MOVE: mc_move idf mc_to N P_INST mc_end point|mc_move cst_int mc_to cst_int P_INST mc_end point;
N:idf | cst_int;


EXPR_ARITH:idf egl CALCUL point;
CALCUL: pa_ouv EXPRESSION1 OPERATEUR EXPRESSION1 pa_fer OPERATEUR CALCUL
		| pa_ouv EXPRESSION1 OPERATEUR EXPRESSION1 pa_fer;
OPERATEUR : mul | plus | moin | slash ;


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