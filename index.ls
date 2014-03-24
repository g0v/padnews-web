Padnews = require \padnews
pad = new Padnews \FRzDUBto4Vj

pub = './public'

require! express
(app     = express!)
  ..use app.router
  #..use express.static pub
  ..set 'view engine' \jade
  ..get '/'     (req, res) -> res.render \index news: pad.news
  ..get '/json' (req, res) ->
    res
      ..setHeader \Access-Control-Allow-Origin '*'
      ..json do
        total: pad.news.length
        latest: pad.news.slice pad.news.length - 42
server  = require(\http).Server app
(io     = require(\socket.io).listen server)
  ..set 'log level' 1
  ..sockets.on \connection (socket) ->
    socket.emit \msg 'http://g0v.today'

pad.run do
  10000
  (event, data, i, diff) ->
    if event is \ready
      server.listen process.env.PORT or 5000
    else
      patch =
        op: if event is \create then \add else \replace
        path: "/#i"
        value: data
      io.sockets.emit \patch, patch
