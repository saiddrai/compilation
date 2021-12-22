/****************CREATION DE LA TABLE DES SYMBOLES ******************/
/***Step 1: Definition des structures de données ***/
#include <stdio.h>
#include <stdlib.h>

typedef struct
{
   int state;
   char name[20];
   char code[20];
   char type[20];
   float val;
 } element;

typedef struct
{ 
   int state; 
   char name[20];
   char code[20];
} elt;

element tab[1000];
elt tabs[40],tabm[40];
extern char sav[20];
char chaine [] = "";

/***Step 2: initialisation de l'état des cases des tables des symbloles***/
/*0: la case est libre    1: la case est occupée*/

void initialisation()
{
  int i;
  for (i=0;i<1000;i++)
  tab[i].state=0;
  
  

  for (i=0;i<40;i++)
    {tabs[i].state=0;
    tabm[i].state=0;}

}


/***Step 3: insertion des entititées lexicales dans les tables des symboles ***/

void inserer (char entite[], char code[],char type[],float val, int y, int i)
{

  switch (y)
 { 
   case 0:/*insertion dans la table des IDF et des const */
       tab[i].state=1;
       strcpy(tab[i].name,entite);
       strcpy(tab[i].code,code);
	     strcpy(tab[i].type,type);
	     tab[i].val=val;
	     break;

   case 1:/*insertion dans la table des mc*/
      tabm[i].state=1;
      strcpy(tabm[i].name,entite);
      strcpy(tabm[i].code,code);
      break;

    case 2:/*insertion dans la table des séparateurs*/
    tab[i].state=1;
    strcpy(tabs[i].name,entite);
    strcpy(tabs[i].code,code);
    break;
 }

}

/***Step 4: La fonction Rechercher permet de verifier  si l'entité existe dèja dans la table des symboles */
void rechercher (char entite[], char code[],char type[],int y, float val )	
{
 int i;
 int current=0;
 switch(y) 
  {
   case 0:/*verifier si l'entité existe dans la table des idf et const*/
      for(i=0;i<1000 ;i++){
        if(tab[i].state==1)
        {
          if(strcmp(entite,tab[i].name))
            {printf("entité existe déjà\n");
            break;} 
        }
        else
         current=i;
			    inserer(entite,code,type,val,y,current); 
       }

        break;
   case 1:/*pour les MC*/
        for(i=0;i<1000;i++){
        if(tabm[i].state==1)
        {
          if(strcmp(entite,tabm[i].name))
          {printf("entité existe déjà\n");
          break;}
        } 
        else
          current=i;
			    inserer(entite,code,type,val,y,current); 
	        
          

         }
        break;
   case 2:/*insertion dans la table des sep*/
            for(i=0;i<1000;i++){
        if(tabs[i].state==1)
        {
          if(strcmp(entite,tabs[i].name))
          {printf("entité existe déjà\n");
          break;}        
        }
        else
          current=i;
			    inserer(entite,code,type,val,y,current); 
         }
        break;      
  }

}


/***Step 5 L'affichage du contenue de la table des symboles ***/

void afficher()
{
  int i;

  printf("/***************Table des symboles IDF*************/\n");
  printf("____________________________________________________________________\n");
  printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite\n");
  printf("____________________________________________________________________\n");
  
  for(i=0;i<1000;i++)
  {	
	
    if(tab[i].state==1)
      { 
        printf("\t|%10s |%15s | %12s | %12f\n",tab[i].name,tab[i].code,tab[i].type,tab[i].val);
         
      }
  }

 
  printf("\n/***************Table des symboles mots clés*************/\n");

  printf("_____________________________________\n");
  printf("\t| NomEntite |  CodeEntite | \n");
  printf("_____________________________________\n");
  
  for(i=0;i<40;i++)
  { 
    if(tabm[i].state==1)
      { 
        printf("\t|%10s |%12s | \n",tabm[i].name, tabm[i].code);
               
      }

  }
  printf("\n/***************Table des symboles séparateurs*************/\n");

  printf("_____________________________________\n");
  printf("\t| NomEntite |  CodeEntite | \n");
  printf("_____________________________________\n");
  
  for(i=0;i<40;i++)
  {

    if(tabs[i].state==1)
      { 
        printf("\t|%10s |%12s | \n",tabs[i].name,tabs[i].code );
        
      }

  }
}