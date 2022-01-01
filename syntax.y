%{
	int nb_ligne=1;
	int nb_colonne=1;
	int i=0;	
	int j=0;
	int t=0;
	int s;
	int operateur;
	int X;
	float k;
	int affect;
	int type;
	int y=0;
	int longe;
	char displ[50];
	char sauvType[25];
	char save[20];
	char sauvCst[20];
	char IDF[100][20];
	char sign[40];
	char IDFF[20];
	char IDFD[100][20];
	char vide[20]; // pour ecraser le contenue de IDFF
	char cstStr[10];
	float cstNum[10];
	float calculResult[10];
	char STR[100];
	char v[20];
	char tem[20];
	int mmmmm;
	int mmm;
	int mmmm;
	int mm;
	int  valCst;
	char *valChar;
	float valFloat;
	char *valStr;



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
%token <str>idf <str>cst_char <entier>cst_int <reel>cst_reel <str>cst_str 
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
																		{printf("\n /52==============> Erreur Semantique Double declaration a la ligne %d <==============\n",nb_ligne);
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
										   		printf("\n ==============> /76Erreur Semantique Double declaration a la ligne %d <==============\n",nb_ligne);
								   				return -1;
												}
								     		}

								   }
								   	Re_TAB(IDF,i); i=0;
								   	};  					 
/*__________________________________________________________________________________________________________________________*/

P_DEC_CONST: mc_const idf TYPE point { 
						for (j=0; j<i; j++)
										{ if(doubleDeclaration(IDF[j])==0)	
											{insererTypeIDF(IDF[j] , save );
											 DonnerVS(IDF[j] ,0);}
										   else { if(doubleDeclaration(IDF[j])==-1)
											{printf("\n ==============> /91 Erreur Semantique Double declaration a la ligne %d <==============\n",nb_ligne);
											return -1;}
										  }
										}
											Re_TAB(IDF,i);i=0;
	
									int i = updateCodeCst($2);
									updateType($2,save);
												
												}

			    | mc_const idf egl CST point {

												if(doubleDeclaration(IDF[j])==-1)
													{printf("\n ==============> Erreur Semantique Double declaration a la ligne %d <==============\n",nb_ligne);
												return -1;}
												else switch (type)
												{
												case 1 : 
													insererTypeIDF($2 ,"INT");
													sprintf(v , "%d" , valCst);
													DonnerVS($2,0);
													insererVAL($2,v);
													
												break;

												case 2 :
													insererTypeIDF($2 ,"FLOAT");
													DonnerVS($2,0);
													sprintf(v , "%f" , valCst);												
													insererVAL($2,v);

												break;

												case 3 :
													insererTypeIDF($2,"CHAR");
													DonnerVS($2,0);
													insererVAL($2,cstStr);
												break;

												case 4 :
													insererTypeIDF($2,"STRING");
													DonnerVS($2,0);
													insererVAL($2,cstStr);
												break;
												
												} 

												Re_TAB(IDF,i);i=0;
												}

										  	 
										
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

CST :cst_char { strcpy(cstStr,$1);   type =3; }
	|cst_str  { strcpy(cstStr,$1); 	 type =4; } 	
	|CST_NUM;
/*__________________________________________________________________________________________________________________________*/

CST_NUM : cst_int  {valCst=$1;valFloat=$1; cstNum[y]=valCst; y++; type=1; } 
		| cst_reel {valCst=$1; valFloat=$1; cstNum[y]=valCst; y++; type=2; }
		;

/*__________________________________________________________________________________________________________________________*/

P_INST : ACC_OR_DIS P_INST
		|CONDITION_IF P_INST
		|MOVE P_INST
		|EXPR_ARITH P_INST
		|;

/*__________________________________________________________________________________________________________________________*/
			
ACC_OR_DIS: ACC | DIS ;

ACC : mc_accept pa_ouv cst_str Dpoint aro idf pa_fer point { strcpy(STR,$3);	
															 SuppMsg($3);

																if (strlen($3)!=3)
															{
																printf("\n ==============> Erreur Semantique : Message accept FAUSSE !!! a la ligne %d",nb_ligne);
																return -1;
															}
															else if (nonDeclared($6)==-1)
																{printf("\n ==============> Erreur Semantique valeur non declarer a la ligne %d <==============\n",nb_ligne);
																 return -1;}
															else {
																switch (STR[1])
																{
																	case '$' :
																	if (get_type($6)!=1) //get type return 1 si l'idf est un entier
																	{
																	printf("Erreur semantique : incompatibilite de Type a la ligne %d", nb_ligne);
																	return -1;
																	}

																	break;

																	case '%' :
																	if (get_type($6)!=2) //get type return 2 si l'idf est un float
																	{
																	printf("Erreur semantique : incompatibilite de Type a la ligne %d", nb_ligne);
																	return -1;
																	}

																	break;

																	case '#' :
																	if (get_type($6)!=4) //get type return 4 si l'idf est un string
																	{
																	printf("Erreur semantique : incompatibilite de Type a la ligne %d", nb_ligne);
																	return -1;
																	}


																	break;

																	case '&' :
																	if (get_type($6)!=3) //get type return 3 si l'idf est un CHAR
																	{
																	printf("Erreur semantique : incompatibilite de Type a la ligne %d", nb_ligne);
																	return -1;
																	}
																	break;
																}
																SuppMsg($3);

																}

		  }	
;    
/*__________________________________________________________________________________________________________________________*/

DIS : mc_display pa_ouv cst_str Dpoint idf_DIS pa_fer point { 	strcpy(displ,$3);
																chercher_sign(displ, sign);
																SuppMsg($3);
																if ( strlen(sign) != t)
																{	
																printf ("Erreur Semantique : y'a un difference entre le nombre des idf est le sign pour afficher !! a la ligne %d",nb_ligne);
																return -1;
																}
																else if (Incomsign(IDFD,sign,t) == -1)
																{
															    printf("Erreur semantique : incompatibilite de Type a la ligne %d", nb_ligne);
																printf ("\n\n\n======== %s \n ======== %s \n ======== %s \n======== %s \n\n\n", &IDFD[0],&IDFD[1],&sign[0],&sign[1]);
															    return -1;
																}

																RE_tab(sign,t);
																Re_TAB(IDFD,t);
																t=0;
																	}


	 |mc_display pa_ouv cst_str pa_fer point {SuppMsg($3);}						

;
/*__________________________________________________________________________________________________________________________*/
idf_DIS : idf vrg idf_DIS {if (nonDeclared($1)==-1)
							{printf("\n ==============> Erreur Semantique valeur non declarer a la ligne %d <==============\n",nb_ligne);
							 return -1;}  
						  else 	 
						  {
							strcpy(IDFD[t],$1);
							t++;
						  }
							 
							 
							 }

		|idf {if (nonDeclared($1)==-1)
				{printf("\n ==============> Erreur Semantique valeur non declarer a la ligne %d <==============\n",nb_ligne);
				 return -1;}
		       	else 	 
		      	  {
		      		strcpy(IDFD[t],$1);
		      		t++;
		      	  }}

;
/*__________________________________________________________________________________________________________________________*/

CONDITION_IF: mc_if pa_ouv CONDITION pa_fer Dpoint P_INST ELSE mc_end point;
/*__________________________________________________________________________________________________________________________*/

ELSE: mc_else Dpoint P_INST  
	  | ;
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


MOVE: mc_move idf mc_to idf P_INST mc_end point {if (nonDeclared($2)==-1 || nonDeclared($4)==-1)
													
													{printf("Erreur Semantique : l 'idf est non Declarer dans la  partie declaration  a la ligne %d !!! \n",nb_ligne);
													return -1;}
													else if (get_type($2) != 1 || get_type($4) != 1)
													{
													printf("Erreur semantique : incompatibilite de Type !! il faut ytiliser que des entier ! -- a la ligne  %d", nb_ligne); 
													return -1 ;
													}
												}

	 |mc_move idf mc_to cst_int P_INST mc_end point { if (nonDeclared($2)==-1)
													
													{printf("Erreur Semantique : l'idf est non Declarer dans la  partie declaration  a la ligne %d !!! \n",nb_ligne);
													return -1;}
													else if (get_type($2) != 1)
													{
													printf("Erreur semantique : incompatibilite de Type !! il faut ytiliser que des entier ! -- a la ligne %d", nb_ligne); 
													return -1;
													}
	 												} 	 		
     |mc_move cst_int mc_to cst_int P_INST mc_end point 

;
/*_________________________________________________________________________________________________________________________*/

EXPR_ARITH:idf egl CALCUL point{
			  					if (nonDeclared($1)==-1)
								{printf("Erreur Semantique : la variable %s est non Declarer dans la  partie declaration  a la ligne %d !!! \n",$1,nb_ligne);
								return -1;
								}else if (DemanderVS($1)==0) {
															printf("Erreur semantique : le %s c'est une constante , tu peut pas fait une affectation  , a la ligne %d",$1,nb_ligne);
															return -1;
															}
								else{} /* if (get_type($1) != get_type()) {printf("Erreur semantique : incompatibilite de Type a la ligne %d", nb_ligne); return -1 ;} */
								
								printf("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv %d \n",calculResult[j]);
								sprintf(v , "%f" , calculResult[j]);												
													insererVAL($1,v);  // zidlha type
								
								}
								
				
				
			
	



		   |idf egl CST point {	
			   								

			   					if (nonDeclared($1)==-1)
								{printf("Erreur Semantique : la variable %s est non Declarer dans la  partie declaration  a la ligne %d !!! \n",$1,nb_ligne);
								return -1;}
								else if ( DemanderVS($1) ==0 ) {
															
															printf("Erreur semantique : le %s c'est une constante , tu peut pas fait une affectation  , a la ligne %d",$1,nb_ligne);
															return -1;
															}
															 
								else if(get_type($1) != type){
									printf("Erreur Semantique : imncompatibilte de type  a la ligne %d !!! \n",nb_ligne);
								return -1;}
								else switch (type)
											{
											case 1 : 
											printf("floooooooat = %f\n",valFloat);
												sprintf(v , "%f" , valFloat);printf("%s\n",v);
												insererVAL($1,v);
											break;
											case 2 :
												sprintf(v , "%f" , valFloat);												
												insererVAL($1,v);
											break;
											case 3 :
												insererVAL($1,cstStr);
											break;
											case 4 :
												insererVAL($1,cstStr);
											break;
											
											}
							
		   }
									
									
									
								


		   |idf egl idf point{  
			   					if(nonDeclared($1) == -1){
									   printf("erreur semantique a la ligne %d: variable %d declare comme constante\n", nb_ligne, $1);return -1;
								   }
																
								if(nonDeclared($3) == -1){
									printf("errur semantique: variable %s non declare a la ligne %d \n",$3,nb_ligne);return -1;
								}
								
								if(get_type($1) != get_type($3)){
									printf("Erreur Semantique : incompatibilte de type  a la ligne %d !!! \n",nb_ligne);
										return -1;
								}

								updateValIdf($1,$3);



								};
/*__________________________________________________________________________________________________________________________*/

CALCUL: idf OPERATEUR idf {
	 				if(nonDeclared($1 )==-1 ){
		 				printf("erreur semantique idf non declare a la ligne %d ",nb_ligne);return -1;
	 				}
	 				if(nonDeclared($3)==-1){
										printf("\n 227==============> Erreur Semantique idf non declaré a la ligne %d <==============\n",nb_ligne); return -1;
									}
					
					

					if(get_type($1) != get_type($3)){
									printf("Erreur Semantique : incompatibilte de type  a la ligne %d !!! \n",nb_ligne);
										return -1;
								}
					calcul($1,$3,operateur,&k);printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=   %f",k);
					calculResult[j]= k; 
					




}
		| idf OPERATEUR CST_NUM {
	 								if(nonDeclared($1) == -1 ){
		 							printf(" erreur semantique idf non declare a la ligne %d ",nb_ligne);
									return -1;
	 							}

								 if(get_type($1) != type){
									printf("Erreur Semantique : imncompatibilte de type  a la ligne %d !!! \n",nb_ligne);
								return -1;}
								
								if(valCst==0 && operateur==4){
									printf("erreur semantique devision sur zerooooooooo a la ligne %d \n",nb_ligne);
									return -1;
								}
								printf("valFloat before the function = %f \n",valFloat);
								 calculIdfXCst($1,&valFloat,operateur,&k); printf("cstcssssssssssssssssssssssssssssss = %f \n",k);
								 					calculResult[j]= k; 

								



		}
		| CST_NUM OPERATEUR CST_NUM{

							//lzm deuxieme variable const2 bach f grammaire ta3 constante n7ato kol const f wahed , meme type lzm deuxieme


		}
		| CST_NUM OPERATEUR idf  {

	 								if(nonDeclared($3 )==-1 ){
		 								printf("erreur semantique idf non declare a la ligne %d ",nb_ligne);return -1;
	 									}
										 
									 if(get_type($3) != type){
									printf("Erreur Semantique : imncompatibilte de type  a la ligne %d !!! \n",nb_ligne);
								return -1;}
								
								 calculIdfXCst($3,&valFloat,operateur,&k); printf("cstcssssssssssssssssssssssssssssss = %f \n",k);	 
										 					calculResult[j]= k; 

										 
										 	}
		| idf OPERATEUR CALCUL	   { 
	 								if(nonDeclared($1 )==-1 ){
		 							printf("erreur semantique idf non declare a la ligne %d ",nb_ligne);return -1;
	 									}
										printf("\n%d\n",k);
								calculIdfXCst($1,&calculResult[j],operateur,&k); printf("cstcssssssssssssssssssssssssssssss = %f \n",k); 
								calculResult[i]= k;


								// na7sbo w n7ato f sommet de pile, resultat ta3 calcul tkon f sommet sema hna ndiro idf operateur sommet de pile, apres nremplaciw sommet l9dim b resultat jdida,
								// f expression arethmetique (idf oper calcul) nvidiw tableau, tkon deja fih ghir 1
								// f le cas ta3 calcul oper calcul, nahasbo sommet de pile operateur l'element li 9bel sommet, na7iwhom w n7ato resultat



									}
		| CALCUL OPERATEUR idf	   {
	 								if(nonDeclared($3 )==-1 ){
		 							printf("erreur semantique idf non declare a la ligne %d ",nb_ligne);return -1;
	 									}
										 
										 calculIdfXCst($3,&calculResult[j],operateur,&k); printf("cstcssssssssssssssssssssssssssssss = %f \n",k); 
								calculResult[i]= k;
										 
										 }
		| CST_NUM OPERATEUR CALCUL {
			calculCstXCst(cstNum[y-1],calculResult[j],operateur,&k);
			calculResult[j]=k;

		}
		| CALCUL  OPERATEUR CST_NUM
		| pa_ouv CALCUL pa_fer	   {}
		| CALCUL OPERATEUR CALCUL  {
			j--; 
			calculCstXCst(calculResult[j], calculResult[j-1],operateur,&k);printf("%d \n",k);
			calculResult[j]=k;
		}
;
/*__________________________________________________________________________________________________________________________*/

OPERATEUR : plus { operateur=1; }| moin { operateur=2; }| mul { operateur=3; }| slash { operateur=4; };
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