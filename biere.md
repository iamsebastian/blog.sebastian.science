---
layout: post
title: Biere, Sude, Gebrautes
permalink: /biere/
last-update: 2016-10-05 10:19:00 +0100
categories: biere
#about: Die Übersicht, was bisher getan wurde
---

> Keinen müden Tropfen, haben wir bisher vermaischt. Keinen. Auch nicht nur einen.

Zumindest ist dies das, was neulich noch hier stand. Mittlerweile gibt es etwas mehr:

{% for beer in site.data.beer %} {% if beer[1].brewed %} - [ **{{ beer[1].name }}** ]( ../{{beer[0]}}/ ) {% else %} - [ {{ beer[1].name }} ]( ../{{beer[0]}}/ ) {% endif %}
{% endfor %}
