gulp = require 'gulp'

gulp.task 'watch', ['setWatch', 'browserSync', 'nodemon'], ->
  gulp.watch 'public/styles/less/**', ['less']
  # Note: The browserify task handles js recompiling with watchify
