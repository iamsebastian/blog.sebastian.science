---
date: 2016-01-01 00:00:00 +0100
layout: post
title: Vorräte
permalink: /vorraete/
image: https://unsplash.it/2000/1200?image=252
image-sm: https://unsplash.it/500/300?image=252
---

Aktuelle Inhalte des bleifreien Vorratslagers

### Hefen:
{% for yeast in site.data.stock.yeasts %} {% assign name = yeast[0] %} {% assign y = site.data.yeasts[name] %} - {{ y.name }}: {{ yeast[1] }} Pkg. [<small>*(nachbestellen)*</small>]({{ y.url }})
{% endfor %}

### Malze & Verbraubares:
{% for malt in site.data.stock.malts %} {% assign name = malt[0] %} {% assign m = site.data.malts[name] %} - {{ m.name }}: {{ malt[1] }}g [<small>*(nachbestellen)*</small>]({{ m.url }})
{% endfor %}

### Hopfen:
{% for hop in site.data.stock.hops %} {% assign name = hop[0] %} {% assign h = site.data.hops[name] %} - {{ h.name }}: {{ hop[1] }}g [<small>*(nachbestellen)*</small>]({{ h.url }})
{% endfor %}
