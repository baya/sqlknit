require 'test/unit'

test_dir = File.dirname(__FILE__)
$:.unshift test_dir if not $:.include? test_dir

lib_dir = File.dirname(File.dirname(__FILE__)) + '/lib'
$:.unshift lib_dir if not $:.include? lib_dir

require 'sqlknit'
