require "#{File.dirname(__FILE__)}/base.rb"
require 'yaml'

module Apiary
  module Okapi
   module Outputs
     class Tap < Apiary::Okapi::Outputs::BaseOutput

       def get
         get_int
         puts "\n\n"
       end
       
       def get_int
         puts "TAP version 13"
         puts "1..#{@results[:count].to_s}"
         if @results[:give_up]
             puts "Bail out! #{@results[:give_up][:error].to_s.tr("\n"," ")}"
             return
         end
         @results[:tests].each { |test|
           if test[:pass]
             o = 'ok '
           else
             o = 'not ok '
           end
           puts o + test[:test_no].to_s + ' ' + test[:description]
           if not test[:pass]
             error_block(test)
           end
         }      
       end

       def error_block(test)
         test[:exp].to_yaml.split(/\n/).each { |line|
           puts "  #{line}"
         }
         puts "  ..."
         
       end
     end
   end
  end
end