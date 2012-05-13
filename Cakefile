{print} = require 'util'
{spawn} = require 'child_process'

spawn_coffee = ->
  coffee = spawn 'coffee', Array.prototype.slice.call(arguments, 0)
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()

task 'build', 'Build lib/ from src/', ->
  spawn_coffee  '--compile', '--output', 'lib', 'src'

task 'watch', 'Watch src/ for changes', ->
  spawn_coffee '--watch', '--compile', '--output', 'lib/', 'src/'
  spawn_coffee '--watch', '--compile', 'test/'

