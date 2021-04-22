#!/bin/bash

######################################################
#         Créer par Lucas Ruffiner et Joaquim Pttet  #
#         Last edit 19.04.2021                       #
#         M122 EPSIC                                 #
######################################################

##############VARIABLE DE DÉPART##############

rouge='\e[0;31m' # Couleur pour les erreurs anti-triche
neutre='\e[0;m'
bleu='\e[1;34m' # Couleur pour les victoires
vert='\e[1;32m' # Couleur pour l'égalité 

J1="X"
J2="O"

tour=1
jeux=true

case=( 1 2 3 4 5 6 7 8 9 )

##############FONCTION MENU##############
menu() {  
  clear
  echo "######################### Morpion Gang #########################

Voici les règles : Pour gagner la partie faut aligner de manière 
horizontal,vertical ou en diagonal les symboles suivant : X et O 

La partie va commencer dans 10 secondes"
sleep 10
}

##############FONCTION TABLEAU##############
tableau() { 
clear
echo ""
echo "          _________________"
echo "         |     |     |     |"
echo "         |  ${case[0]}  |  ${case[1]}  |  ${case[2]}  |"
echo "         |     |     |     |"
echo "         |  ${case[3]}  |  ${case[4]}  |  ${case[5]}  |"
echo "         |     |     |     |"
echo "         |  ${case[6]}  |  ${case[7]}  |  ${case[8]}  |"
echo "         |_____|_____|_____|"
echo ""
}

##############FONCTION JOUEURS##############
joueurs(){ 
  if [[ $(($tour % 2)) == 0 ]]
  then
    jouer=$J2
    echo -n "Joueur 2 choisi une case: "
  else
    echo -n "Joueur 1 choisi une case: "
    jouer=$J1
  fi

  read choix

##############CONTRÔLE DES CARACTÈRES##############
  while (($choix<1))||(($choix>9)); do
	  echo -e "${rouge}/!\ Saisie invalide (1 à 9) /!\ :${neutre}"
	  read choix
	done

  space=${case[($choix -1)]} 

##############CONTRÔLE DES CASES##############
  if [[ ! $choix =~ ^-?[0-9]+$ ]] || [[ ! $space =~ ^[0-9]+$  ]]
  then 
    echo -e "${rouge}/!\ Saisie invalide, case déjà utilisé /!\ ${neutre}"
    joueurs
  else
    case[($choix -1)]=$jouer
    ((tour=tour+1))
  fi
  space=${case[($choix-1)]} 
}

##############CONTRÔLE DES COMBINAISONS##############
controle_combinaison() {
  if  [[ ${case[$1]} == ${case[$2]} ]]&& \
      [[ ${case[$2]} == ${case[$3]} ]]; then
    jeux=false
  fi
  if [ $jeux == false ]; then
    if [ ${case[$1]} == 'X' ];then
      echo -e "${vert}Joueur 1 gagne !!!${neutre}"
      return
      else
    if [ ${case[$1]} == 'O' ];then
      echo -e "${vert}Joueur 2 gagne !!!${neutre}"
      return 
    fi
  fi
  fi
}

##############FONCTION VICTOIRE##############
victoire(){
  if [ $jeux == false ]; then return; fi
  controle_combinaison 0 1 2
  if [ $jeux == false ]; then return; fi
  controle_combinaison 3 4 5
  if [ $jeux == false ]; then return; fi
  controle_combinaison 6 7 8
  if [ $jeux == false ]; then return; fi
  controle_combinaison 0 4 8
  if [ $jeux == false ]; then return; fi
  controle_combinaison 2 4 6
  if [ $jeux == false ]; then return; fi
  controle_combinaison 0 3 6
  if [ $jeux == false ]; then return; fi
  controle_combinaison 1 4 7
  if [ $jeux == false ]; then return; fi
  controle_combinaison 2 5 8
  if [ $jeux == false ]; then return; fi

  if [ $tour -gt 9 ]; then 
    $jeux == false
    echo -e "${bleu}Egalité!${neutre}"
    rejouer
  fi
}

##############FONCTION POUR RELANCER UNE PARTIE##############
rejouer() {
    echo "Voulez-vous rejouer ? (y/n)" >&2
    read -rsn1 input
    if [ "$input" = "y" ]; then
      turn=1
      jeux=true
      case=( 1 2 3 4 5 6 7 8 9 )
      fin_jeu
    fi
    return 0
}


fin_jeu() {
  tableau
  while $jeux
  do
    joueurs
    tableau
    victoire
  done
  rejouer
}

menu
fin_jeu

##############SOURCES##############
#https://www.linuxtricks.fr/wiki/bash-memo-pour-scripter
#https://fr.wikibooks.org/wiki/Programmation_Bash/
#https://devhints.io/bash
#https://devdocs.io/bash/
#M122 Cours bash.pdf
