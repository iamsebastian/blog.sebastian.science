---
layout: default
---

Hier folgt die Auflistung der einzelnen Beete.

{% for bed in site.data.beds %}
  {% assign this_bed = site.data.beds[bed.id] %}
  {% assign pls = site.data.plantings[bed.id] %}

  <svg version="1.0" xmlns="http://www.w3.org/2000/svg" class="svg-beds"
  width="{{ bed.x }}" height="{{ bed.y }}" viewBox="0 0 {{ bed.x }} {{ bed.y }}"
  preserveAspectRatio="xMidYMid meet">
    <defs>
      {% comment %}<pattern id="wegPattern" width="25" height="16" patternUnits="userSpaceOnUse">{% endcomment %}
      <pattern id="wegPattern" width="12" height="8" patternUnits="userSpaceOnUse">
        <path d="M0,0 L 2,2 L 4,0 L 5,8 L 6,0 L 8,2 L 10,0" stroke-width="0.5" stroke="#503000" fill="none"/>
      </pattern>
      <pattern id="pastinakePattern" x="5" width="25" height="8" patternUnits="userSpaceOnUse">
        <rect width="25" height="25" opacity="0.3" fill="lightblue"/>
        <path d="M0 15L7.5 0L15 15Z" fill="lightgreen"/>
      </pattern>
      <pattern id="boundPattern" width=".50" height=".50" patternContentUnits="objectBoundingBox">
        <circle cx=".250" cy=".250” r=".1" fill="#ec7677" />
      </pattern>
      <pattern id="raukePattern" width="3" height="3" patternTransform="rotate(45)" patternUnits="userSpaceOnUse">
        <rect x="0" y="0" width="100%" height="100%" opacity="0.3" fill="greenyellow"/>
        <rect x="1.7" y="1.7" width="100%" height="100%" opacity="0.9" fill= "cyan" />
      </pattern>
      <pattern id="radiesPattern" width="3" height="3" patternTransform="rotate(45)" patternUnits="userSpaceOnUse">
        <rect x="0" y="0" width="100%" height="100%" opacity="0.3" fill="greenyellow"/>
        <rect x="1.7" y="1.7" width="100%" height="100%" opacity="0.6" fill= "blue" />
      </pattern>
      <pattern id="karottePattern" width="5" height="3" patternTransform="rotate(45)" patternUnits="userSpaceOnUse">
        <rect x="0" y="0" width="100%" height="100%" opacity="0.3" fill="greenyellow"/>
        <rect x="3.7" y="1.6" width="100%" height="100%" opacity="0.6" fill="red"/>
      </pattern>
      <pattern id="kartoffelnPattern" width="60" height="25" patternUnits="userSpaceOnUse">
        <line x1="0" x2="60" y1="2" y2="23" stroke="lightgreen"/>
        <circle cx="30" cy="12" r="6" stroke="lightgreen" fill="white"/>
        <circle cx="30" cy="12" r="8" stroke="lightgreen" fill="none"/>
      </pattern>
      <pattern id="kuerbisPattern" width="33" height="33" patternUnits="userSpaceOnUse">
        <line x1="0" x2="100" y1="0" y2="100" stroke="orange"/>
        <circle cx="16" cy="16" r="12" stroke="orange" fill="white"/>
      </pattern>
      <pattern id="tomatenPattern" width="50" height="75" patternUnits="userSpaceOnUse">
        {% comment %}<line x1="10" x2="40" y1="35" y2="35" stroke="tomato"/>{% endcomment %}
        {% comment %}<line x1="25" x2="25" y1="20" y2="50" stroke="tomato"/>{% endcomment %}
        <polygon points="25,30 15,15 23,20 25,18 27,20 35,15" fill="#ED8" stroke="none"/>
        <circle cx="25" cy="35" r="12" stroke="tomato" fill="white"/>
        <rect x="0" width="100%" height="100%" y="33" fill="white"/>
        <line x1="20" x2="30" y1="33" y2="33" stroke="tomato"/>
        <line x1="25" x2="25" y1="33" y2="42" stroke="tomato"/>
      </pattern>
      <pattern id="chiliPattern" width="50" height="75" patternUnits="userSpaceOnUse">
        <circle cx="25" cy="35" r="8" stroke="red" stroke-width="2" fill="white"/>
        <circle cx="40" cy="35" r="12" stroke="none" fill="white"/>
      </pattern>
      <pattern id="paprikaPattern" width="50" height="75" patternUnits="userSpaceOnUse">
        <line x1="17" x2="17" y1="20" y2="50" stroke-width="2" stroke="green"/>
        <circle cx="25" cy="35" r="8" stroke="green" fill="white"/>
      </pattern>
      <pattern id="skartoffelnPattern" width="50" height="75" patternUnits="userSpaceOnUse">
        <line x1="10" x2="40" y1="25" y2="45" stroke="green"/>
        <line x1="15" x2="35" y1="20" y2="50" stroke="green"/>
        <circle cx="20" cy="27" r="7" stroke="lightsalmon" fill="white"/>
        <circle cx="30" cy="43" r="7" stroke="lightsalmon" fill="white"/>
        <circle cx="25" cy="35" r="9" stroke="lightsalmon" fill="white"/>
      </pattern>
      <pattern id="maisPattern" width="45" height="40" patternUnits="userSpaceOnUse">
        <polygon points="10,0 5,10 10,10 5,30 15,30 10,10 15,10" fill="none" stroke="gold"/>
      </pattern>
      <pattern id="feuerbohnePattern" width="60" height="20" patternUnits="userSpaceOnUse">
        <polygon points="5,5 10,1 15,5 13,10 7,10" fill="none" stroke="darkorange"/>
        <polygon points="9,8 9,18 11,18 11,8" fill="none" stroke="forestgreen"/>
      </pattern>
      <pattern id="kapuziner-kressePattern" width="20" height="10" patternUnits="userSpaceOnUse">
        <line x1="0" x2="20" y1="2" y2="8" stroke="lightgreen"/>
        <circle cx="10" cy="5" r="2" stroke="lightgreen" fill="white"/>
      </pattern>
      <pattern id="borretschPattern" width="20" height="10" patternUnits="userSpaceOnUse">
        <path d="M2,0 L 2,5 L 11,0 L 11,5 L 20,0" stroke-width="1" stroke="cornflowerblue" fill="none"/>
      </pattern>
    </defs>

  {% for p in pls %}
    {% assign type = site.data.plants[p.type] %}
    {% assign ar = type.ar %}
    {% if p.w %}{% assign ar = p.w %}{% endif %}
    <g transform="translate({{p.x}},{% if p.y %}{{ p.y }}{% else %}0{% endif %})" {% if type.opacity %}opacity="{{ type.opacity }}"{% endif %} height="10">
      <title>{{ type.name }}</title>
      <rect opacity="0.9" x="0" fill="url(#{{ p.type | slugify }}Pattern)" y="0" height="{% if p.h %}{{ p.h }}{% else %}100%{% endif %}" width="{{ ar }}"></rect>
    </g>
    <g class="sibling_hover">
      <rect x="0" y="0" width="100%" height="40" opacity="0.9" fill="white"/>
      <text x="4" y="12" fill="grey">{{ type.name }} {% if p.sub %}({{ p.sub }}){% endif %} </text>

      <g transform="translate(0,20)" class="info_hover">
        <rect opacity="0.8" x="0" fill="white" y="0" height="{% if p.h %}{{ p.h }}{% else %}100%{% endif %}" width="25"></rect>

        {% if type.eq_dislikes %}
          {% assign dislikes = site.data.plants[type.eq_dislikes].dislikes %}
        {% else if type.dislikes %}
          {% assign dislikes = type.dislikes %}
        {% endif %}
        {% if dislikes %}
          <g transform="translate(4,0)" stroke-width="2" stroke="red" fill="orange">
            <circle cx="7" cy="7" r="6" fill="none"/>
            <line x1="2" x2="12" y1="2" y2="12" />
            <line x1="2" x2="12" y1="12" y2="2" />
          </g>
          {% comment %}<text transform="translate(5,18),rotate(90)">{% endcomment %}
          <text transform="translate(22,10)">
            {{ dislikes | array_to_sentence_string }}
          </text>
        {% else %}
          <g stroke-width="1" fill="red">
            <path d="M6,19 C -2,8 10,0 14,8 C 18,0 30,8 22,19 L 14,28"/>
          </g>
        {% endif %}
      </g>
    </g>
  {% endfor %}

  </svg>
{% endfor %}
