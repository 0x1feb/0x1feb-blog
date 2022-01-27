hugo_date=`date '+%Y-%m-%dT%T'`
hugo_dir=content/posts/`date '+%Y/%m/%d'`
mkdir -p $hugo_dir
tmpl="---
title: \"title\"
slug: \"slug\"
date: "$hugo_date"+09:00
draft: false
categories: [\"\"]
tags: [\"\"]
---
"
echo "$tmpl" >> $hugo_dir/index.md
