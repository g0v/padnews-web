socket = io.connect '/'
socket.on \patch' (data) ->
  i = +data.path.substr 1

  $sec = $ "<section class=\"entry\"><span class=\"time\"><a href=\"/#i\">#{data.value.time}</a></span><span class=\"location\">[#{data.value.location}]</span></section>"
  for p in data.value.content
    $sec.append "<p class=\"content\">#p</p>"

  switch data.op
  | \add     => $ \body   .prepend $sec
  | \replace => $ \.entry .eq(-i-1)replaceWith $sec
  | \remove  => $ \.entry .eq(-i-1)remove!

$ \.empty .click (e) ->
  $that = $ this
  e.preventDefault!
  $.ajax do
    url:      "/json#{$that.attr \href}",
    dataType: \json
    success:  (data, status) !->
      return if status isnt \success
      for p in data.content
        $that.before "<p class=\"content\">#p</p>"
      $that.remove!
