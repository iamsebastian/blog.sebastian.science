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

<span class="not_available">Ausgeblendete</span> Samen sind derzeit nicht vergügbar / aufgebracht. <span class="not_shareable">Durchgestrichene</span> können / dürfen / werden *nicht* getauscht.

Die Zahl hinter dem Doppelpunkt stellt meinen aktuellen Bestand dar.

<ul class="no-list-style">
{% for seed in site.data.seeds %}
  <li>
  {% assign props_or_count = seed[1] %}
  {% if props_or_count.share == false %}
    <span class="not_shareable">
    {% if props_or_count.count == 0 %}
      <span class="not_available">{{ seed[0] }}: {{ props_or_count.count }}</span>
    {% else %}
      {{ seed[0] }}: {{ props_or_count.count }}
    {% endif %}
    </span>
  {% else %}
    {% if props_or_count == 0 %}
      <span class="not_available">{{ seed[0] }}: {{ props_or_count }}</span>
    {% else %}
      {{ seed[0] }}: {{ props_or_count }}
    {% endif %}
  {% endif %}
  </li>
{% endfor %}
</ul>
