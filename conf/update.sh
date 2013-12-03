#!/bin/bash
export LANGUAGE=en_US.UTF-8
ROOT='/home/moztw/translate/var/repo'

echo
date
echo

if [ $USER != www-data ]
then
	echo 'You must run this script as www-data (try sudo -u www-data)'
	exit
fi

echo 'Pulling English source code from upstream...'

for REPO in `ls $ROOT -1`
do
	echo '* '$REPO
	cd $ROOT/$REPO
	if [ -e $ROOT/$REPO/.hg ]
	then
		# pull everything down then update to default
		hg pull -u
		hg update -c -r default
		# show tip information
		hg tip
	fi
	if [ -e $ROOT/$REPO/.svn ]
	then
		svn update
	fi
	if [ -e $ROOT/$REPO/.git ]
	then
		git pull
		git log -n 1
		echo
	fi
done

#Importing mozilla-central and Gaia repositories to Narro
for PRJID in 9 11 12 13 14 15
do  
	echo
	echo 'Importing l10n-aurora projects...'
	/usr/bin/php /home/moztw/translate/www/narro/includes/narro/importer/narro-cli.php --import --minloglevel 3 --project $PRJID --user 1 --check-equal --import-unchanged-files --template-lang en-US --translation-lang zh-TW --template-directory /home/moztw/translate/www/narro/data/import/$PRJID/en-US --translation-directory /home/moztw/translate/www/narro/data/import/$PRJID/zh-TW
	echo
	echo 'Done.'
done

for PRJID in 26 30 31
  do
    echo
    echo 'Importing Gaia projects...'
    /usr/bin/php /home/moztw/translate/www/narro/includes/narro/importer/narro-cli.php --import --minloglevel 3 --project $PRJID --user 1 --check-equal --import-unchanged-files --template-lang en-US --translation-lang zh-TW --template-directory /home/moztw/translate/www/narro/data/import/$PRJID/en-US --translation-directory /home/moztw/translate/www/narro/data/import/$PRJID/zh-TW
    echo
    echo 'Done.'
done


echo
date
echo

exit
