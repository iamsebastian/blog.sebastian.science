---
layout: post
title: Biere, Sude, Gebrautes
permalink: /biere/
date: 2016-10-05 10:19:00 +0100
last-update: 2017-05-09 13:05:03 +0100
categories: biere
image: https://unsplash.it/2000/1200?image=602
image-sm: https://unsplash.it/500/300?image=602
---

> Keinen müden Tropfen, haben wir bisher vermaischt. Keinen. Auch nicht nur einen.

Zumindest ist dies das, was neulich noch hier stand. Mittlerweile gibt es etwas mehr:

> Gebrautes

<ul class="alpha-list-style">
{% for beer in site.data.beer %}
  {% if beer[1].brewed %}
    <li><a href="../{{beer[0]}}/"><b>{{ beer[1].name }}</b></a></li>
  {% endif %}
{% endfor %}
</ul>

> Theoretische Abwägungen und Resteplanung

<ul class="alpha-list-style">
{% for beer in site.data.beer %}
  {% unless beer[1].brewed %}
    <li><a href="../{{beer[0]}}/">{{ beer[1].name }}</a></li>
  {% endunless %}
{% endfor %}
</ul>
