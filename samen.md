---
layout: post
title: Sämereien
permalink: /samen/
last-update: 2017-02-08 12:39:10 +0100
categories: samen
#about: Samen-Bestand
---

> Es gilt noch was aus zu säen

<ul class="no-list-style">
{% for seed in site.data.seeds %}
  <li> {{ seed[0] }}: {{ seed[1] }} </li>
{% endfor %}
</ul>
