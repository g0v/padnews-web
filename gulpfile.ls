require! <[ gulp gulp-livescript gulp-stylus ]>
spawn = require \child_process .spawn

config =
  server:
    source: './src/server'
    build:  '.'
  client:
    source: './src/client'
    build:  './public'

gulp.task \app ->
  gulp.src "#{config.server.source}/index.ls"
    .pipe gulp-livescript!
    .pipe gulp.dest "#{config.server.build}/"

gulp.task \js ->
  gulp.src "#{config.client.source}/ls/index.ls"
    .pipe gulp-livescript!
    .pipe gulp.dest "#{config.client.build}/js/"

gulp.task \css ->
  gulp.src "#{config.client.source}/stylus/main.styl"
    .pipe gulp-stylus!
    .pipe gulp.dest "#{config.client.build}/css/"

gulp.task \build <[ app js css ]>

gulp.task \default <[ build ]> ->
  child = spawn \foreman <[ start ]> cwd: process.cwd!
