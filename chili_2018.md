---
layout: post
title: Chilis 2018
permalink: /chili_2018/
date: 2017-10-23 04:45:00
last-update: 2017-10-23 04:45:00
categories: chili
image: https://unsplash.it/2000/1200?image=602
image-sm: https://unsplash.it/500/300?image=602
---

{% assign placeholder = "[COLOR=#FFFFFF]—[/COLOR]" %}

> Chili Listing für 2018

<ul class="alpha-list-style">
{% for chili in site.data.chili_2018 %}
{% assign name = chili[0] %}
{% assign props = chili[1] %}
{% assign c = site.data.chili[name] %}
  <li>
    {{ c.species }}: <b>{{ name }}</b>
    <!--
       -{% for s in props.seeds %}
       -  {{ s.sown }}
       -{% endfor %}
       -->
  </li>
{% endfor %}
</ul>

<code>
[table]
[tr] [th]Gattung[/th] [th]Sortenname[/th] [th](reife) Farbe[/th] [th]Schärfe[/th] [th]#[/th] [th]gesät am[/th] [th]gekeimt am[/th] [th]Keimdauer in d[/th] [th]Extra Informationen[/th] [/tr]
{% for chili in site.data.chili_2018 %} {% assign name = chili[0] %} {% assign props = chili[1] %} {% assign c = site.data.chili[name] %} {% unless props.seeds %} [tr] [td]{{ c.species }}[/td] [td]{{ name }}[/td] [td]{{ c.color }}[/td] [td]{{ c.heat | default: placeholder }}[/td] [td]{{ placeholder }}[/td] [td]{{ placeholder }}[/td] [td]{{ placeholder }}[/td] [td]{{ placeholder }}[/td] [td]{{ placeholder }}[/td] [/tr] {% else %} {% for s in props.seeds %} [tr] [td]{{ c.species }}[/td] [td]{{ name }}[/td] [td]{{ c.color }}[/td] [td]{{ c.heat | default: placeholder }}[/td] [td]{{ forloop.index }}[/td] [td]{{ s.sown | default: placeholder }}[/td] [td]{{ s.sprout | default: placeholder }}[/td] [td]{{ s | sprout_time_filter | default: placeholder }}[/td] {% unless s.died %} [td]{{ s.extra | default: placeholder }}[/td] {% else %} [td]&#9962;: {{ s.died }}[/td] {% endunless %} [/tr] {% endfor %} {% endunless %} {% endfor %}
[/table]
</code>
