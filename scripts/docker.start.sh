#!/bin/sh

#node_modulesインストール
echo "npm install"
npm install 

#vue起動
echo "npm run serve. "
npm run build
#rm -rf node_modules
npm run serve

#メモを出力
#echo "localhost:18080"
