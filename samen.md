---
layout: post
title: Sämereien
permalink: /samen/
date: 2017-02-08 12:39:10 +0100
last-update: 2017-06-30 12:39:10 +0100
categories: samen
image: https://unsplash.it/2000/1200?image=102
image-sm: https://unsplash.it/500/300?image=102
---

> Es gilt noch was aus zu säen

<ul class="no-list-style">
{% for seed in site.data.seeds %}
  <li> {{ seed[0] }}: {{ seed[1] }} </li>
{% endfor %}
</ul>
