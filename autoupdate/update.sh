#!/bin/bash

GIT=`which git`
ECHO=

## Following variableis will be overriden after reading the parameters.
REPODIR=
SCRIPTROOT="/home/moztw/repo/base/autoupdate"
WEBROOT=
DLFILES="dl/ns/index.shtml dl/ff/index.shtml dl/moz/index.shtml dl/tb/index.shtml dl/nvu/index.shtml inc/dl*.html"
URLROOT=

## Optional parameters.
OPT_MD5=0
OPT_CACHE=0
OPT_BASE=0
OPT_WWW=0
OPT_STAGE=0
OPT_TRANSLATE=0
OPT_IRCLOG=0
OPT_PHOTOS=0
OPT_DEMO=0
OPT_WIKI=0

## Handle options.

for var in "$@"; do
	if [ $var = "md5" ]; then
		OPT_MD5=1
	elif [ $var = "cache" ]; then
		OPT_CACHE=1
	elif [ $var = "stage" ]; then
		OPT_STAGE=1
	elif [ $var = "www" ]; then
		OPT_WWW=1
	elif [ $var = "demo" ]; then
		OPT_DEMO=1
	elif [ $var = "irclog" ]; then
		OPT_IRCLOG=1
	elif [ $var = "photos" ]; then
		OPT_PHOTOS=1
	elif [ $var = "translate" ]; then
		OPT_TRANSLATE=1
	elif [ $var = "wiki" ]; then
		OPT_WIKI=1
	fi
done

function update_src {
    echo "Update source..."
    $ECHO cd $REPODIR && $ECHO $GIT pull 2>&1
    return $?;
}

function update_xml_news {
    if [ 1 == $OPT_WWW ] || [ 1 == $OPT_STAGE ]; then
		echo "Updating XML news..."
		$ECHO cd $WEBROOT && $ECHO $SCRIPTROOT/genxmlnews.pl $WEBROOT $WEBROOT/xmlnews.rdf
    	return $?;
	fi
}

function update_cache {
	if [ 1 == $OPT_WWW ] || [ 1 == $OPT_STAGE ]; then
		echo "Rebuilding cache..."
    	local rebuild=
	    if [ 1 == $OPT_CACHE ]; then
    	    rebuild="rebuild"
	    fi
    	$ECHO cd $WEBROOT && $ECHO $SCRIPTROOT/cacheshtml.sh $WEBROOT $URLROOT $rebuild 2>&1
	    return $?
	fi
}

function update_md5 {
    if [ 1 == $OPT_WWW ] || [ 1 == $OPT_STAGE ]; then
		echo "Updating MD5..."
    	$ECHO cd $WEBROOT && $ECHO $SCRIPTROOT/updateMD5.pl $DLFILES 2>&1
	    return $?
	fi
}

## Setup path

if [ 1 == $OPT_BASE ]; then
	REPODIR="/home/moztw/repo/base"
	WEBROOT="/home/moztw/repo/base"
elif [ 1 == $OPT_STAGE ]; then
   	REPODIR="/home/moztw/repo/www-stage.moztw.org"
    WEBROOT="/home/moztw/repo/www-stage.moztw.org"
    URLROOT="http://www-stage.moztw.org"
elif [ 1 == $OPT_WWW ]; then
    REPODIR="/home/moztw/repo/www.moztw.org"
    WEBROOT="/home/moztw/repo/www.moztw.org"
    URLROOT="http://moztw.org"
elif [ 1 == $OPT_TRANSLATE ]; then
	REPODIR="/home/moztw/repo/translate.moztw.org"
	WEBROOT="/home/moztw/repo/translate.moztw.org"
	URLROOT="http://translate.moztw.org"
elif [ 1 == $OPT_IRCLOG ]; then
	REPODIR="/home/moztw/repo/irclog.moztw.org"
	WEBROOT="/home/moztw/repo/irclog.moztw.org"
	URLROOT="http://irclog.moztw.org"
elif [ 1 == $OPT_PHOTOS ]; then
	REPODIR="/home/moztw/repo/photos.moztw.org"
	WEBROOT="/home/moztw/repo/photos.moztw.org"
	URLROOT="http://photos.moztw.org"
elif [ 1 == $OPT_DEMO ]; then
	REPODIR="/home/moztw/repo/demo.moztw.org"
	WEBROOT="/home/moztw/repo/demo.moztw.org"
	URLROOT="http://demo.moztw.org"
elif [ 1 == $OPT_WIKI ]; then
	REPODIR="/home/moztw/repo/wiki.moztw.org"
	WEBROOT="/home/moztw/repo/wiki.moztw.org"
	URLROOT="http://wiki.moztw.org"
fi

## Print configuration

echo "=============================="
echo "using git: $GIT"
if [ 1 == $OPT_STAGE ]; then
	echo "Updating website: stage"
elif [ 1 == $OPT_WWW ]; then
	echo "Updating website: production"
elif [ 1 == $OPT_DEMO ]; then
	echo "Updating website: demo"
elif [ 1 == $OPT_IRCLOG ]; then
	echo "Updating website: irclog"
elif [ 1 == $OPT_TRANSLATE ]; then
	echo "Updating website: translate"
elif [ 1 == $OPT_PHOTOS ]; then
	echo "Updating website: photos"
elif [ 1 == $OPT_WIKI ]; then
	echo "Updating website: wiki"
elif [ 1 == $OPT_BASE ]; then
	echo "Updating base website managing scripts"
fi
echo "=============================="
echo ""

## Run updating procedure.

if [[ ! $@ ]]; then
	echo "!!! You must give arguments! Exiting..."
	exit
fi		

update_src
if [ 0 != $? ]; then
    echo "!!! Update source fail"
    exit 1
fi

if [ 1 = $OPT_CACHE ]; then
	update_cache
	if [ 0 != $? ]; then
    	echo "!!! Update cache fail"
	    exit 1
	fi
fi

if [ 1 = $OPT_MD5 ]; then
    update_md5
    if [ 0 != $? ]; then
        echo "!!! Update md5 fail"
        exit 1
    fi
fi

update_xml_news
if [ 0 != $? ]; then
    echo "!!! Update XML news fail"
    exit 1
fi
