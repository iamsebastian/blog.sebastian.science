---
date: 2016-01-01 00:00:00 +0100
layout: post
title: Vorräte
permalink: /vorrat/
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
<table>
  <tr>
  <th>Bestellt <br>—Verbraut <br>= Rest <br>—Verplant <br>&rarr; frei</th>
    <th>verbraut</th>
    <th>verplant</th>
  </tr>
  {% for hop in site.data.stock.hops %}
    {% assign name = hop[0] %}
    {% assign h = site.data.hops[name] %}
    {% assign weight = hop[1] %}
    {% assign left = weight %}
    {% assign planned = 0.0 %}
    {% assign brewed = 0.0 %}

    <tr> <th colspan="3">{{h.name}}</th> </tr>

    <tr>
    {% for beer in site.data.beer %}
      {% assign b = beer[1] %}
      {% for beer_hop in b.hops %}
        {% if name == beer_hop.type %}
          {% if b.brewed == true %}
            {% assign brewed = brewed|plus:beer_hop.weight %}
          {% else if b.brewed == false %}
            {% assign planned = planned|plus:beer_hop.weight %}
          {% endif %}
        {% endif %}
      {% endfor %}
    {% endfor %}

    <td>
    {% assign left = weight|minus:brewed %}
    {% if weight > left %}
      {{weight}}g
      <br>- {{brewed}}g
    {% endif %}
    <br>= <b>{{left}}g</b>
    {% if planned > 0 %}
      <br>- {{planned}}g
      <br>&rarr; {{left|minus:planned}}g
    {% endif %}
    </td>

      <td>
      {% for beer in site.data.beer %}
        {% assign b = beer[1] %}
        {% for beer_hop in b.hops %}
          {% if name == beer_hop.type %}
            {% if b.brewed == true %}
              <li><small>{{beer_hop.weight}}g @ <a href="/{{beer[0]}}">{{b.name}}</a></small></li>
            {% endif %}
          {% endif %}
        {% endfor %}
      {% endfor %}
      </td>

      <td>
      {% for beer in site.data.beer %}
        {% assign b = beer[1] %}
        {% for beer_hop in b.hops %}
          {% if name == beer_hop.type %}
            {% if b.brewed == false %}
              <i><li><small>{{beer_hop.weight}}g @ <a href="/{{beer[0]}}">{{b.name}}</a></small></li></i>
            {% endif %}
          {% endif %}
        {% endfor %}
      {% endfor %}
      </td>
    </tr>
  {% endfor %}
<table>
