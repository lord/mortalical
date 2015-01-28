require 'prawn'

module Mortalical
  module Calendar
    def self.generate
      Prawn::Document.generate("hello.pdf") do |pdf|
        pdf.font_families.update("LeagueGothic" => {
          normal: "./LeagueGothic-Regular.ttf"
        })
        pdf.font "LeagueGothic"
        pdf.text "Hello World!"
      end
    end
  end
end