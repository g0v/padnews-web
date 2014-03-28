(function(){
  var socket;
  socket = io.connect('/');
  socket.on('patch\'', function(data){
    var $sec, i$, ref$, len$, p, i;
    $sec = $("<section class=\"entry\"><span class=\"time\">" + data.value.time + "</span><span class=\"location\">[" + data.value.location + "]</span></section>");
    for (i$ = 0, len$ = (ref$ = data.value.content).length; i$ < len$; ++i$) {
      p = ref$[i$];
      $sec.append("<p class=\"content\">" + p + "</p>");
    }
    i = +data.path.substr(1);
    switch (data.op) {
    case 'add':
      return $('body').prepend($sec);
    case 'replace':
      return $('.entry').eq(-i - 1).replaceWith($sec);
    case 'remove':
      return $('.entry').eq(-i - 1).remove();
    }
  });
  $('.empty').click(function(e){
    var $that;
    $that = $(this);
    e.preventDefault();
    return $.ajax({
      url: "/json" + $that.attr('href'),
      dataType: 'json',
      success: function(data, status){
        var i$, ref$, len$, p;
        if (status !== 'success') {
          return;
        }
        for (i$ = 0, len$ = (ref$ = data.content).length; i$ < len$; ++i$) {
          p = ref$[i$];
          $that.before("<p class=\"content\">" + p + "</p>");
        }
        $that.remove();
      }
    });
  });
}).call(this);
