%option yylineno
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



%}

lettre [a-z]
chiffre [0-9]
IDF [A-Z]({lettre}|{chiffre})*
INT_CST \([+-]{chiffre}+\)|{chiffre}+
FLOAT_CST ({chiffre}+,{chiffre}+)|(\([[+-]{chiffre}+,{chiffre}+\))
CHAR_CST '.'
STRING_CST \"[\n.]*\"
COMMENT #[^!\n]*!
MSGDISP_ACC \".*[$%#&].*\"
MSGDISP \".*\"
%%

{COMMENT}  printf ("Un Commentaire reconnue\n");
          
                                                     /*declaration des mots cles*/
IDENTIFICATION   {     printf("MC ident fication reconnu \n");          }
DIVISION         {     printf("MC division reconnu \n");                }
PROGRAM          {     printf("MC programme reconnu \n");               }
ID               {     printf("MC id  reconnu \n");                     }
DATA             {     printf("MC data reconnu \n");                    } 
WORKING          {     printf("MC working reconnu \n");                 }
STORAGE          {     printf("MC storage reconnu \n");                 }
SECTION          {     printf("MC section reconnu \n");                 }
PROCEDURE        {     printf("MC procedure reconnu \n");               }
STOP             {     printf("MC stop reconnu \n");                    }
RUN              {     printf("MC run reconnu \n");                     }
SIZE             {     printf("MC size reconnu \n");                    }
LINE             {     printf("MC line reconnu\n");                     }
ACCEPT           {     printf("MC ACCEPT reconnu \n");                  }
DISPLAY          {     printf("MC DISPLAY reconnu \n");                 }
IF               {     printf("MC IF reconnu \n");                      }
ELSE             {     printf("MC ELSE reconnu \n");                    }
END              {     printf("MC END reconnu \n");                     }
MOVE             {     printf("MC MOVE reconnu \n");                    }
TO               {     printf("MC TO reconnu \n");                      }
CONST            {     printf("MC const reconnu \n");                   }
                  
INTEGER          {     printf("MC integer reconnu \n");                 }
CHAR             {     printf("MC char reconnu \n");                    }	
FLOAT            {     printf("MC float reconnu \n");                   }	 
STRING           {     printf("MC string reconnu \n");                  }  
                  
AND              {     printf("oper and reconnu \n");                   }
OR               {     printf("oper or reconnu \n");                    }
NOT              {     printf("oper not reconnu \n");                   }	
".L."            {     printf("oper > reconnue \n");                    }
".G."            {     printf("oper < reconnue \n");                    }
".GE."           {     printf("oper < reconnue \n");                    }
".LE."           {     printf("oper <= reconnue \n");                   }
".EQ."           {     printf("oper == reconnu \n");                    }
".DI."           {     printf("oper =/= reconnue \n");                  }
                  
"$"              {     printf("$ reconnu \n");                          }
"%"              {     printf("% reconnu \n");                          }
"#"              {     printf("# reconnu \n");                          }
","              {     printf(", reconnu \n");                          }
"&"              {     printf("& reconnu \n");                          }
"@"              {     printf("@ reconnu \n");                          }
":"              {     printf(": reconnu \n");                          }
"/"              {     printf("/ reconnu \n");                          }
"\""             {     printf("\" reconnu \n");                         }
"="              {     printf("= reconnu \n");                          }
"+"              {     printf("+ reconnu \n");                          }
"-"              {     printf(" - reconnu \n");                         }
"*"              {     printf("* reconnu \n");                          }
"|"              {     printf("| reconnu \n");                          }
"("              {     printf(" par ouver reconnu \n");                 }
")"              {     printf( ") reconnu \n");                         }
"."              {     printf(". reconnu \n");                          }
{IDF} 			 {if (yyleng <=9)
				 {	   printf("IDF reconnu %s \n",yytext);   			 }
       			 else {	printf("ERREUR ligne :  IDF %s est tres long\n", yytext);}}
{CHAR_CST}  	{printf("CST char reconnu \n");			}
{INT_CST}  {if(atoi(yytext)<=32767 && atoi(yytext)>= -32768){printf("CST entiere reconnue \n");		   }
			else{	printf("erreur lexicale a la ligne : et colonne :  depassement de capacite\n") ;}}
{FLOAT_CST}      {printf("CST reelle reconnue \n");    }
{STRING_CST}     {    printf("CST string reconnue \n");     }
{MSGDISP_ACC}    {   printf("msg pour instruction display reconnu \n"); }
{MSGDISP}        {      printf("msg pour instruction display reconnu \n");}	
[ \t ]           {}
\n  {}
.  				{printf ("erreur lexicale a la ligne : ,et la colonne : \n"); }
%%
