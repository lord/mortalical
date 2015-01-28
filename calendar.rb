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
          draw_year(pdf, 1872+n, 0+83*n, 530, n==0)
        end
      end
    end

    private
    MONTH_LABELS = {
      0 => "JAN",
      1 => "FEB",
      2 => "MAR",
      3 => "APR",
      4 => "MAY",
      5 => "JUN",
      6 => "JUL",
      7 => "AUG",
      8 => "SEP",
      9 => "OCT",
      10 => "NOV",
      11 => "DEC",
    }

    def self.draw_year(pdf, year_num, x, y, draw_labels = false)
      pdf.fill_color "333333"
      pdf.text_box year_num.to_s, at: [x, y+24], align: :left, size: 36, width: 70, height: 50, valign: :top
      pdf.text_box rand(1..100).to_s + "%", at: [x, y+4.75], align: :right, size: 10, width: 70, height: 50, valign: :top
      year = year_data(year_num)
      dow = year[:first_day]
      week = 0
      year[:months].each_with_index do |day_count, month_num|
        if draw_labels == true
          pdf.fill_color "333333"
          offset = if dow==0 then 0 else 10 end
          pdf.text_box MONTH_LABELS[month_num], at: [x-55, y-9-week*10-offset], align: :right, size: 10, width: 50, height: 50, valign: :top
        end
        pdf.stroke_color "333333"
        pdf.fill_color "d6d6d6"
        pdf.line_width=0.5
        day_count.times do
          if [0,6].include? dow
            pdf.rectangle [x+dow*10, y-9-week*10], 10, 10
            pdf.fill
          end
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