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
  char val[20];
  int VS;         /*si 1 --> varriable si 0 --> Constante */
} element;

typedef struct
{
  int state;
  char name[20];
  char code[20];
} elt;

element tab[1000];
elt tabs[40], tabm[40];
extern char sav[20];
char chaine[] = "";

/***Step 2: initialisation de l'état des cases des tables des symbloles***/
/*0: la case est libre    1: la case est occupée*/

void initialisation()
{
  int i;
  for (i = 0; i < 1000; i++)
    tab[i].state = 0;

  for (i = 0; i < 40; i++)
  {
    tabs[i].state = 0;
    tabm[i].state = 0;
  }
}

/***Step 3: insertion des entititées lexicales dans les tables des symboles ***/

void inserer(char entite[], char code[], char type[], char val[], int y, int i)
{

  switch (y)
  {
  case 0: /*insertion dans la table des IDF et des const */
    tab[i].state = 1;
    strcpy(tab[i].name, entite);
    strcpy(tab[i].code, code);
    strcpy(tab[i].type, type);
    strcpy(tab[i].val,val);
    break;

  case 1: /*insertion dans la table des mc*/
    tabm[i].state = 1;
    strcpy(tabm[i].name, entite);
    strcpy(tabm[i].code, code);
    break;

  case 2: /*insertion dans la table des séparateurs*/
    tabs[i].state = 1;
    strcpy(tabs[i].name, entite);
    strcpy(tabs[i].code, code);
    break;
  }
}

/***Step 4: La fonction Rechercher permet de verifier  si l'entité existe dèja dans la table des symboles */
void rechercher(char entite[], char code[], char type[], int y, char val[20])
{
  int i;
  int current = 0;
  switch (y)
  {
  case 0: /*verifier si l'entité existe dans la table des idf et const*/
    for (i = 0; i < 1000; i++)
    {
      if (tab[i].state == 0)
      {
        current = i;
        inserer(entite, code, type, val, y, current);
        break;
      }
      else if (strcmp(tab[i].name, entite) == 0)
      {
        break;
      }
    }

    break;
  case 1: /*pour les MC*/
    for (i = 0; i < 40; i++)
    {
      if (tabm[i].state == 0)
      {
        current = i;
        inserer(entite, code, type, val, y, current);
        break;
      }
      else if (strcmp(tabm[i].name, entite) == 0)
      {
        break;
      }
    }
    break;
  case 2: /*insertion dans la table des sep*/
    for (i = 0; i < 40; i++)
    {
      if (tabs[i].state == 0)
      {
        current = i;
        inserer(entite, code, type, val, y, current);
        break;
      }
      else if (strcmp(tabs[i].name, entite) == 0)
      {
        break;
      }
    }
    break;
  }
}

/***Step 5 L'affichage du contenue de la table des symboles ***/

void afficher()
{
  int i;

  printf("\n/***************Table des symboles IDF ET CONST*************/\n");
  printf("____________________________________________________________________\n");
  printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite\n");
  printf("____________________________________________________________________\n");

  for (i = 0; i < 1000; i++)
  {

    if (tab[i].state == 1)
    {
      printf("\t|%10s  |%13s | %11s | %12s |\n", tab[i].name, tab[i].code, tab[i].type, tab[i].val);
    }
  }
  printf("____________________________________________________________________\n\n");

  printf("\n/***************Table des symboles Mot cles*************/\n");

  printf("_______________________________________\n");
  printf("\t| NomEntite     |  CodeEntite | \n");
  printf("_______________________________________\n");

  for (i = 0; i < 40; i++)
  {
    if (tabm[i].state == 1)
    {
      printf("\t|%14s |%12s | \n", tabm[i].name, tabm[i].code);
    }
  }
  printf("_______________________________________\n\n");
  printf("\n/***************Table des symboles separateurs*************/\n");

  printf("_________________________________________\n");
  printf("\t| NomEntite |  CodeEntite | \n");
  printf("_________________________________________\n");

  for (i = 0; i < 40; i++)
  {

    if (tabs[i].state == 1)
    {
      printf("\t|%10s |%12s | \n", tabs[i].name, tabs[i].code);
    }
  }
  printf("_____________________________________\n");
}

int Rechercher_PosIDF(char entite[])
{
  int i = 0;
  while (i < 1000)
  {
    if (strcmp(entite, tab[i].name) == 0)
      return i;
    i++;
  }

  return -1;
}

void insererTypeIDF(char entite[], char type[])
{
  int pos;
  pos = Rechercher_PosIDF(entite);
  if (pos != -1)
  {
    strcpy(tab[pos].type, type);
  }
}

int get_type(char entite[]){
  int pos=Rechercher_PosIDF(entite);
  if (pos != -1)
  {
  if (strcmp(tab[pos].type,"INT")==0)      return 1;
  if (strcmp(tab[pos].type,"FLOAT")==0)   return 2;
  if (strcmp(tab[pos].type,"CHAR")==0)    return 3;
  if (strcmp(tab[pos].type,"STRING")==0)  return 4;
}

}

int doubleDeclaration(char entite[])
{
  int pos;
  pos = Rechercher_PosIDF(entite);
  if (strcmp(tab[pos].type, "") == 0)
    return 0;
  else
    return -1;
}


int nonDeclared(char entite[]){
 int pos;
  pos = Rechercher_PosIDF(entite);
  if (strcmp(tab[pos].type, "") == 0)
    return -1;
  else
    return 0;
}




/* int rechercherDeclared(char entite[]){
   int i = 0;
  while (i < 1000)
  {
    if (strcmp(entite, tab[i].name) == 0)
      if(strcmp(tab[i].type,"")==0)
        return -1;
      else 
        return i;
    i++;
  }

  return -1;
 }
 */

void modifierIDF(char idf[], char type[]){
  strcpy(tab[Rechercher_PosIDF(idf)].type, type);
 }

/*void insererTaille(char entite[], int taille)
 {
  int i = Rechercher_PosIDF(entite);
  char Taille=taille+"0";
  strcpy(tab[i].val,taille);
 }*/


/*char rechercherVal(char entite[])
 {
 int pos;
 char k[20];
 pos = Rechercher_PosIDF(entite);
 strcpy(k,tab[pos].val);
 return k;
 }*/

void Change_affich(char val[20])
 { 
 char R [20];
	int i,j=0;
	if ( val[0] =='(' )
	{ for (i=1 ; i<strlen(val)-1 ; i++) {
                        	R[j]=val[i];
                          j++; }
	strcpy(val ,R); 
  }
  
	for (i=0 ; i<strlen(val) ; i++){ 
                        if (val[i]==',') val[i]='.';
                                  }

 }

void DonnerVS(char entite[] , int i)
 {
 tab[Rechercher_PosIDF(entite)].VS =i;
 }


 int DemanderVS(char entite[])
{
   int V;
   V=tab[Rechercher_PosIDF(entite)].VS; 
	return V ; 
}


void Re_TAB(char TAB[100][20] , int n ){
	int i;
	for (i=0 ; i<n ; i++)
		strcpy (TAB[i] , "");
  }
 void insererVAL(char entite[], char val[])
{
  int pos = Rechercher_PosIDF(entite);
  if  (pos != -1) {
                    strcpy(tab[pos].val,val);
                   }
}                   






int updateCodeCst(char entite[]){
    int i = Rechercher_PosIDF(entite);
    strcpy(tab[i].code, "CST");printf("constante updated===================================== %s \n", tab[i].code);
    return 0;
}


void updateType(char entite[], char type[]){
  int i =0;printf("========================================================");
  while (i < 1000)
  {
    if (strcmp(entite, tab[i].name) == 0){
      strcpy(tab[i].type, type);
      break;
    }
    i++;
  }
}


/*int idfVsType( char entite[], int type2[] ){
  int i = Rechercher_PosIDF(entite);
  if (i>-1)
    if(strcmp(tab[i].type,type2)!=0)
      return -1;
  
   return 0;


}
*/ 

int idfVsIdf(char entite1[], char entite2[] ){
  int i = Rechercher_PosIDF(entite1);
  int j = Rechercher_PosIDF(entite2);
  if (i>-1)
    if(strcmp(tab[i].type,tab[j].type)!=0)
      return -1;
  
   return -1;
}


void calcul(char entite1[],char entite2[],int oper,float *x){

  // atof 
  int i = Rechercher_PosIDF(entite1);
  int j = Rechercher_PosIDF(entite2);
  char val1[10];
  char val2[10];
  strcpy(val1,tab[i].val);
  strcpy(val2,tab[j].val);

  float v1= atof(val1);
  float v2 = atof(val2);
  float result=0;
printf("%f %f \n",v1,v2);
  switch(oper){
    case 1:
        result = v1+v2;printf("%f\n",result);
      *x= result; break;
    case 2:
      result = v1-v2;printf("%f\n",result);
      *x= result;break;
    case 3:
      result= v1*v2;printf("%f\n",result);
      *x= result;break;
    case 4:
      result=v1/v2;printf("%f\n",result);
      *x= result;break;
  }

}


void calculIdfXCst(char entite1[],float v2,int oper,float *x){

  // atof 
  int i = Rechercher_PosIDF(entite1);
  char val1[10];

  strcpy(val1,tab[i].val);

  float v1= atof(val1);
  
  float result=0;
printf("%f %f \n",v1,v2);
  switch(oper){
    case 1:
        result = v1+v2;printf("%f\n",result);
      *x= result;break;
    case 2:
      result = v1-v2;printf("%f\n",result);
      *x= result;break;
    case 3:
      result= v1*v2;printf("%f\n",result);
      *x= result;break;
    case 4:
      result=v1/v2;printf("%f\n",result);
      *x= result;break;
  }

}



void updateValCst(char entite[],float x){
  int i = Rechercher_PosIDF(entite);
  char v[10];
    printf("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa %d \n",x);

  sprintf(v , "%f" , x);	
  strcpy(tab[i].val,v);
}


void affecter(char entite[], int valInt, float valFloat, char valChar, char valStr[],int type){
  int i = Rechercher_PosIDF(entite);
  char str[7];
  char val[20];
  switch(type){
    case 1: 
      val[0]=valChar;
      break;
    case 2:
      strcpy(val,valStr);
      break;
    case 3:
      snprintf(str, sizeof(str), "%d", valInt);
      strcpy(val,str);
      break;
    case 4:
      gcvt(valFloat, 6, val);
      break;
  }
  strcpy( tab[i].val,val);

}

/*void affectInt(char entite[], int val){
  int i = Rechercher_PosIDF(entite);
  tab[i].val=;
  
  
}*/ 


void updateValIdf(char entite1[],char entite2[]){
  int i = Rechercher_PosIDF(entite1);
  int j = Rechercher_PosIDF(entite2);

  if(i!=-1 && j != -1){
    strcpy(tab[i].val,tab[j].val);
  }
}