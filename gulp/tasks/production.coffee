gulp = require 'gulp'

gulp.task 'production', [
  'browserify'
  'install'
  'less'
  'copy'
]
