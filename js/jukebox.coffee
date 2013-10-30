centW = window.innerWidth / 100
centH = window.innerHeight / 100
paused = no
vol = 400

animateTo = (thing, x, y, time, complete) ->
  props = x: centW * x, y: centH * y, onComplete: complete
  if !complete
    delete props.complete
  TweenMax.to thing.translation, time, props

groups = []
window.onload = () ->
  elem = document.getElementById "two"
  params = autostart: yes, fullscreen: yes
  two = new Two(params).appendTo(elem)
  body = two.makeRectangle 0, 0, centW * 15, centW * 15
  slot = two.makeRectangle 0, 0 - centW * 4, centW * 5, centH * 2
  body.fill = "#7B3F00"
  body.stroke = "black"
  body.linewidth = 2
  slot.fill = "black"
  slot.stroke = "none"
  jukebox = two.makeGroup [body, slot, cover]
  jukebox.translation.set centW * 50, centH * 65

  recordMaker = (pos, opacity, name, colors, x, y) ->
    base = two.makeCircle 0, 0, centW * 2.5
    line1 = two.makeLine centW * -2.5, 0, centW * 2.5, 0
    line2 = two.makeLine 0, centW * -2.5, 0, centW * 2.5
    colortworing = two.makeCircle 0, 0, centW * 1.5
    coloronering = two.makeCircle 0, 0, centW * 1
    base.fill = "black"
    colortworing.fill = colors[1]
    coloronering.fill = colors[0]
    base.stroke = "#444"
    line1.stroke = "#444"
    line2.stroke = "#444"
    colortworing.stroke = "none"
    coloronering.stroke = "none"
    if colors[0] is "black"
      coloronering.stroke = "white"
      coloronering.linewidth = 1.5
    parts = [base, line1, line2, colortworing, coloronering]
    if !colors[0]
      parts.splice 1, 2
      parts.splice 0, 0, line1, line2
      a = 2 * Math.PI * Math.random()
      b = Math.random() + Math.random()
      c = Math.random() * (centW * 2.5)
      prev = [c * Math.cos a, c * Math.sin a]
      for i in [0...100] by 1
        t = 2 * Math.PI * Math.random()
        u = Math.random() + Math.random()
        r = Math.random() * (centW * 2.5)
        scratch = two.makeLine r * Math.cos(t), r * Math.sin(t), prev[0], prev[1]
        scratch.stroke = "#444"
        parts.push scratch
        prev = [r * Math.cos(t), r * Math.sin(t)]
    if !colors[1] and colors[0]
      parts.splice 1, 2
      parts.splice 2, 0, line1, line2
    hole = two.makeCircle 0, 0, centW * 0.5
    hole.fill = "white"
    parts.push hole
    record = two.makeGroup parts
    record.name = name
    record.pos = pos
    record.opacity = opacity
    record.translation.set x, y
    groups.push record
  eleven   = recordMaker("l", 1, "eleven",   [],                     centW * 25, centH * 10)
  thirteen = recordMaker("l", 1, "thirteen", ["white", "#FCD20A"],   centW * 35, centH * 10)
  blocks   = recordMaker("c", 1, "blocks",   ["#D83D2E"],            centW * 45, centH * 10)
  cat      = recordMaker("c", 1, "cat",      ["#44FF07", "#1A5402"], centW * 55, centH * 10)
  chirp    = recordMaker("r", 1, "chirp",    ["#FA000A", "#6A0005"], centW * 65, centH * 10)
  far      = recordMaker("r", 1, "far",      ["#A9FF09", "#22FF7A"], centW * 75, centH * 10)
  mall     = recordMaker("b", 1, "mall",     ["#3600FE", "#8758FF"], centW * 25, centH * 25)
  mellohi  = recordMaker("b", 1, "mellohi",  ["white", "#A003FD"],   centW * 35, centH * 25)
  stal     = recordMaker("b", 1, "stal",     ["black"],              centW * 45, centH * 25)
  strad    = recordMaker("b", 1, "strad",    ["white"],              centW * 55, centH * 25)
  wait     = recordMaker("b", 1, "wait",     ["#6F94DB", "#395FA4"], centW * 65, centH * 25)
  ward     = recordMaker("b", 1, "ward",     ["#7AAB06", "#0C5942"], centW * 75, centH * 25)
  cover = two.makeRectangle centW * 49.95, centH * 63.5, centW * 5.2, centW * 6
  cover.fill = "#7B3F00"
  cover.stroke = "none"

  nocreeps = confirm "Would you like to skip 11 and 13?\nSome people find 11 and 13 creepy."
  if nocreeps is true
    TweenMax.to groups[0], 1, opacity: 0
    TweenMax.to groups[1], 1, opacity: 0
    setTimeout () ->
      noCreeps()
    , 1000
  else
    setTimeout () ->
      console.log nocreeps
      play()
    , 1000
  noCreeps = () ->
    groups.splice(0, 2)
    groups[0].pos = "l"
    groups[1].pos = "l"
    groups[4].pos = "r"
    for i in [0...4] by 1
      animateTo groups[i], groups[i].translation.x / centW - 15, groups[i].translation.y / centH, 0.5
    for i in [4...10] by 1
      animateTo groups[i], groups[i].translation.x / centW - 5, groups[i].translation.y / centH, 0.5
    setTimeout () ->
      animateTo groups[4], 20, 40, 0.25, () -> animateTo groups[4], 80, 40, 1, () -> animateTo groups[4], 80, 10, 0.5, -> animateTo groups[4], 70, 10, 0.25
    , 500
    setTimeout () ->
      play()
    , 4000

  insertRecord = (record) ->
    console.log "playing", record.name
    id = document.getElementById record.name
    title = document.getElementById "songTitle"
    title.innerHTML = record.name.toString()
    if record.pos is "c"
      animateTo record, 50, record.translation.y / centH, 0.5
    if record.pos is "l"
      animateTo record, record.translation.x / centW + 5, 10, 0.15, () -> animateTo record, record.translation.x / centW, 40, 0.35
    if record.pos is "r"
      animateTo record, record.translation.x / centW - 5, 10, 0.15, () -> animateTo record, record.translation.x / centW, 40, 0.35
    if record.pos is "b"
      animateTo record, record.translation.x / centW, 40, 0.5
    setTimeout () ->
      animateTo record, 50, 40, 0.5, () ->
        animateTo record, 50, 60, 0.5, () ->
          id.play()
          TweenMax.to title, 0.5, opacity: 1
          setTimeout () ->
            TweenMax.to title, 0.5, opacity: 0
          , 2500
          TweenMax.to record, 50000, ease:Linear.easeNone, rotation: 200000
    , 500
    id.addEventListener "ended", () -> removeRecord(record)
  removeRecord = (record) ->
    playQ.shift()
    fadeOut(record)
    setTimeout () ->
      TweenMax.killAll()
      TweenMax.to record, 0, rotation: 0
      if nocreeps
        animateTo record, 50, 40, 0.5, () ->
          if record.name is "blocks"
            animateTo record, 35, 40, 0.5, () -> animateTo record, 35, 10, 0.25, () -> animateTo record, 30, 10, 0.25
          if record.name is "cat"
            animateTo record, 45, 40, 0.5, () -> animateTo record, 45, 10, 0.25, () -> animateTo record, 40, 10, 0.25
          if record.name is "chirp"
            animateTo record, 45, 40, 0.5, () -> animateTo record, 45, 10, 0.25, () -> animateTo record, 50, 10, 0.25
          if record.name is "far"
            animateTo record, 55, 40, 0.5, () -> animateTo record, 55, 10, 0.25, () -> animateTo record, 60, 10, 0.25
          if record.name is "mall"
            animateTo record, 65, 40, 0.5, () -> animateTo record, 65, 10, 0.25, () -> animateTo record, 70, 10, 0.25
          if record.name is "mellohi"
            animateTo record, 30, 40, 0.5, () -> animateTo record, 30, 25, 0.5
          if record.name is "stal"
            animateTo record, 40, 40, 0.5, () -> animateTo record, 40, 25, 0.5
          if record.name is "strad"
            animateTo record, 50, 40, 0.5, () -> animateTo record, 50, 25, 0.5
          if record.name is "wait"
            animateTo record, 60, 40, 0.5, () -> animateTo record, 60, 25, 0.5
          if record.name is "ward"
            animateTo record, 70, 40, 0.5, () -> animateTo record, 70, 25, 0.5
      else
        animateTo record, 50, 40, 0.5, () ->
          if record.name is "eleven"
            animateTo record, 30, 40, 0.5, () -> animateTo record, 30, 10, 0.5, () -> animateTo record, 25, 10, 0.5
          if record.name is "thirteen"
            animateTo record, 40, 40, 0.5, () -> animateTo record, 40, 10, 0.5, () -> animateTo record, 35, 10, 0.5
          if record.name is "blocks"
            animateTo record, 50, 10, 0.5, () -> animateTo record, 45, 10, 0.5
          if record.name is "cat"
            animateTo record, 50, 10, 0.5, () -> animateTo record, 55, 10, 0.5
          if record.name is "chirp"
            animateTo record, 60, 40, 0.5, () -> animateTo record, 60, 10, 0.5, () -> animateTo record, 65, 10, 0.5
          if record.name is "far"
            animateTo record, 70, 40, 0.5, () -> animateTo record, 70, 10, 0.5, () -> animateTo record, 75, 10, 0.5
          if record.name is "mall"
            animateTo record, 25, 40, 0.5, () -> animateTo record, 25, 25, 0.5
          if record.name is "mellohi"
            animateTo record, 35, 40, 0.5, () -> animateTo record, 35, 25, 0.5
          if record.name is "stal"
            animateTo record, 45, 40, 0.5, () -> animateTo record, 45, 25, 0.5
          if record.name is "strad"
            animateTo record, 55, 40, 0.5, () -> animateTo record, 55, 25, 0.5
          if record.name is "wait"
            animateTo record, 65, 40, 0.5, () -> animateTo record, 65, 25, 0.5
          if record.name is "ward"
            animateTo record, 75, 40, 0.5, () -> animateTo record, 75, 25, 0.5
      setTimeout () ->
        play()
      , 2000
    , 2500
  two.update()

  randomSort = () ->
    r = Math.random()
    r > 0.5 ? -1 : 1
  records = []
  playQ = []
  setTimeout () ->
    records = groups.slice 0
    playQ = records.sort randomSort
  , 999
  play = () ->
    if playQ[0]
      insertRecord playQ[0]
    else
      window.location.reload()
  fadeOut = (record) ->
    id = document.getElementById record.name
    fade = setInterval () ->
      if vol > 0
        vol--
        id.volume = vol / 400
      else
        id.pause()
        clearInterval fade
        vol = 400
    , 5

  window.onkeypress = () ->
    id = document.getElementById playQ[0].name
    if event.which is 13
      removeRecord playQ[0]
    if event.which is 32
      if paused
        id.play()
        TweenMax.resumeAll()
        paused = no
      else
        id.pause()
        TweenMax.pauseAll()
        paused = yes
