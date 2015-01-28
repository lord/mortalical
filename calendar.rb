require 'prawn'
require 'date'

module Mortalical
  module Calendar
    def self.generate
      Prawn::Document.generate("hello.pdf", page_layout: :landscape) do |pdf|
        pdf.font_families.update("LeagueGothic" => {
          normal: "./LeagueGothic-Regular.ttf"
        })
        pdf.font "LeagueGothic"

        9.times do |n|
          draw_year(pdf, 1872+n, -15+85*n, 525)
        end
      end
    end

    private
    def self.draw_year(pdf, year_num, x, y)
      pdf.font_size 36
      pdf.draw_text year_num.to_s, at: [x-1, y]
      year = year_data(year_num)
      dow = year[:first_day]
      week = 0
      pdf.line_width=0.5
      pdf.stroke_color "333333"
      year[:months].each do |day_count|
        day_count.times do
          pdf.rectangle [x+dow*10, y-9-week*10], 10, 10
          pdf.stroke
          dow += 1
          if dow == 7
            dow = 0
            week += 1
          end
        end
      end
    end
    def self.year_data(year)
      months = (1..12).map do |month|
        days_in_month(year, month)
      end

      {
        year: year,
        months: months,
        first_day: first_day_of_year(year)
      }
    end

    def self.days_in_month(year, month)
      (Date.new(year, 12, 31) << (12-month)).day
    end

    # 0=sunday, 1=monday...6=saturday
    def self.first_day_of_year(year)
      Date.new(year, 1, 1).cwday % 7
    end
  end
end