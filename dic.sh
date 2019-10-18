#!/bin/bash

word=$1
curl -SsL "http://cn.bing.com/dict/search?q=$word" |\
	grep -Eo '<meta name="description" content="(.+) " ?/>' |\
	sed -E 's/<meta name="description" content="必应词典为您提供.+的释义，(.+)" ?\/>/\1/' |\
	sed -E 's/(.*)(，)(.*)/\1 \3/' | awk -v WORD=$word '{
		c=0;
		for(i=1;i<=NF;i++) {
			if(match($i, "^[a-z]+\\.|网络释义：$") != 0) {
				if(c!=0) printf "\n";
				c++;
			}
      # 只输出释义，去掉发音
      if(match($i, "美\\[") == 0 && match($i, "英\\[") == 0) {
        printf "%s ",$i;
      }
		}
		printf "\n";
	}'
