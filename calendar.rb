require 'prawn'

module Mortalical
  module Calendar
    def self.generate
      Prawn::Document.generate("hello.pdf") do |pdf|
        pdf.text "Hello World!"
      end
    end
  end
end