#!/bin/bash

configGrep ()
{
	ret=$(cat ${scriptDir}/${configScript}  | grep -v "#" | grep "$1=" | cut -d "=" -f 2);
	echo $ret
}


# $1 : keyPath
# $2 : cipherPath
# pass = openssl rsautl -decrypt -inkey ${keyPath} -in ${cipherPath}

decryptPass ()
{
	pass=$(openssl rsautl -decrypt -inkey $1 -in $2 )
	echo $pass
}

# $1 : base Directory
# $2,$3,...$n : directory / file name
# ret = $1/$2/$3/.../$n

concatPath ()
{
	ret=$1
	for arg in "${@:2}"
	do
		ret=${ret}/${arg}
	done
	echo $ret
}


# $1 : base Directory
# $2,$3,...$n-2 : directory
# $n-1 : file name
# $n : extension
# ret = $1/.../$n-2/$n-1.$n

concatPathWithExtension ()
{	
	ret=$1
	if [ $# -gt 3 ]; then
		for arg in "${@:2:$#-2}"
		do
			ret=${ret}/${arg}
		done
	fi
	lastFileName=${@:$#-1:1}
	ext=${@:$#:1}
	ret=${ret}/${lastFileName}.${ext}
	echo $ret
}
