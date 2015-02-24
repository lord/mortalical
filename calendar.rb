require 'prawn'
require 'date'

module Mortalical
  module Calendar
    def self.generate(start_year, is_tabloid, fill_existing_days)
      settings = if is_tabloid
        { page_size:  [792, 1224] }
      else
        { page_layout: :landscape }
      end
      Prawn::Document.generate("hello.pdf", settings) do |pdf|
        pdf.font_families.update("LeagueGothic" => {
          normal: "./LeagueGothic-Regular.ttf"
        })
        pdf.font "LeagueGothic"

        fill_date = if fill_existing_days == true
          Time.now.to_date
        else
          false
        end

        if is_tabloid
          draw_title(pdf, -9, 530+612-9)
          6.times do |n2|
            pdf.start_new_page if n2 > 0
            9.times do |n|
              # be sure to ignore the year the title is drawn in
              draw_year(pdf, start_year+n+18*n2-1, -9+85*n, 530+612, n==0, fill_date) unless n == 0 && n2 == 0
              draw_year(pdf, start_year+n+9+18*n2-1, -9+85*n, 530, n==0, fill_date)
            end
          end
        else
          draw_title(pdf, -9, 530-9)
          12.times do |n2|
            pdf.start_new_page if n2 > 0
            9.times do |n|
              draw_year(pdf, start_year+n+9*n2-1, -9+85*n, 530, n==0, fill_date) unless n == 0 && n2 == 0
            end
          end
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

    def self.draw_title(pdf, x, y)
      pdf.text_box "M\nO\nR\nT\nA\nL\nI\nC\nA\nL", at: [x, y], align: :center, size: 52, width: 70, height: 520, valign: :center
    end

    def self.draw_year(pdf, year_num, x, y, draw_labels = false, fill_date = false)
      # Draw text at top
      pdf.fill_color "000000"
      pdf.text_box year_num.to_s, at: [x, y+24], align: :left, size: 36, width: 70, height: 50, valign: :top
      pdf.text_box rand(1..100).to_s + "%", at: [x, y+4.75], align: :right, size: 10, width: 70, height: 50, valign: :top

      # Draw day grid
      for_each_day(year_num, x, y) do |month, day, dow, week, xday, yday|
        if draw_labels == true && day == 1
          pdf.fill_color "000000"
          offset = if dow==0 then 0 else 10 end
          pdf.text_box MONTH_LABELS[month], at: [x-53, yday-offset-1], align: :right, size: 10, width: 50, height: 50, valign: :top
        end

        pdf.stroke_color "000000"
        pdf.fill_color "d6d6d6"
        pdf.line_width=0.3

        if [0,6].include? dow
          pdf.rectangle [xday, yday], 10, 10
          pdf.fill
        end

        if fill_date && fill_date > Date.new(year_num, month+1, day)
          padding = 3.5
          pdf.stroke do
            pdf.line [xday+10-padding, yday-padding], [xday+padding, yday-10+padding]
          end
          pdf.stroke do
            pdf.line [xday+padding, yday-padding], [xday+10-padding, yday-10+padding]
          end
        end
        pdf.rectangle [xday, yday], 10, 10
        pdf.stroke
      end
      for_each_day(year_num, x, y) do |month, day, dow, week, xday, yday|
        if month != 0 && day == 1
          pdf.line_width=1.5
          pdf.stroke do
            if dow == 0
              pdf.move_to x, yday
            else
              pdf.move_to x, yday-10
              pdf.line_to x+dow*10, yday-10
              pdf.line_to x+dow*10, yday
            end
            pdf.line_to x+7*10, yday
          end
        end
      end
    end

    def self.for_each_day(year_num, x, y)
      year = year_data(year_num)
      dow = year[:first_day]
      week = 0
      year[:months].each_with_index do |day_count, month_num|
        day_count.times do |day_in_month|
          yield(month_num, day_in_month+1, dow, week, x+dow*10, y-9-week*10)
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