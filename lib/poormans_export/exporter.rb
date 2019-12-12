# frozen_string_literal: true

require 'csv'
module PoormansExport
  class Exporter
    def initialize(collection, fields, headers)
      @collection = collection
      @head = []
      @fields = []
      @types = []
      fields.each do |f|
        if f.is_a?(Symbol) || f.is_a?(String)
          @head << f.to_s
          @fields << f
        elsif f.is_a?(Hash)
          @head << f.keys.first
          @fields << f.values.first
          @types << f[:type]
        end
      end
      @headers = headers
    end

    def csv_string(params = {})
      options = { col_sep: ',' }
      options.merge! params
      csv_string = CSV.generate(options) do |csv|
        if @collection.first.class.nil?
          class_name = @collection
        elsif @collection.first.class != NilClass
          class_name = @collection.first.class
        end

        header = []
        @head.each do |header_field|
          header <<
            if class_name
              class_name.human_attribute_name(header_field.gsub(/_ids?/, ''))
            else
              header_field
            end
        end
        csv << header

        @collection.each do |item|
          row_array = []
          @fields.each do |field|
            row_array << Exporter.field_value(item, field)
          end
          csv << row_array
        end
      end
      csv_string
    end

    def excel_string(params = {})
      template_path = params[:template]
      start_on_row = params[:start_on_row] || 0
      formats = params[:formats] || { 0 => { weight: :bold } }
      formats[@headers.size + 1] = { weight: :bold } unless @headers.empty?
      workbook = params[:workbook]
      workbook ||=
        if template_path.present?
          Spreadsheet.open(template_path)
        else
          Spreadsheet::Workbook.new
        end
      sheet = template_path ? workbook.worksheet(0) : workbook.create_worksheet
      sheet.name = params[:sheet_name] if params[:sheet_name]
      current_row = start_on_row

      if @collection.first.class.nil?
        class_name = @collection
      elsif @collection.first.class != NilClass
        class_name = @collection.first.class
      end

      unless @headers.empty?
        if @headers[0]
          sheet.row(current_row).concat [@headers[0]]
          current_row += 1
        end
        now = I18n.l(Time.zone.now, format: :compact)
        sheet.row(current_row).concat ["#{I18n.t(:export_time)}: #{now}"]
        current_row += 1
        if @headers[1]
          sheet.row(current_row).concat [@headers[1]]
          current_row += 1
        end
      end

      header = []
      @head.each do |header_field|
        header <<
          if class_name
            class_name.human_attribute_name(header_field.gsub(/_ids?/, ''))
          else
            header_field
          end
      end
      sheet.row(current_row).concat header
      current_row += 1

      @collection.each do |item|
        row_array = []
        @fields.each do |field|
          row_array << Exporter.field_value(item, field)
        end
        sheet.row(current_row).replace row_array
        @types.each_with_index do |type, idx|
          case type
          when Date
            cell_format = 'DD-MM-YYYY'
          when Time
            cell_format = 'DD-MM-YYYY HH:MM:SS'
          end
          next unless cell_format

          sheet.row(current_row).set_format(
            idx,
            Spreadsheet::Format.new(number_format: cell_format)
          )
        end
        current_row += 1
      end

      formats.each do |k, v|
        format = Spreadsheet::Format.new(v)
        if k.respond_to?(:each)
          k.each do |sub_k|
            sheet.row(sub_k).default_format = format
          end
        else
          sheet.row(k).default_format = format
        end
      end

      if params[:fmt] == :obj
        workbook
      else
        output = StringIO.new
        workbook.write(output)
        output.string
      end
    end

    def self.field_value(item, field)
      if item && field.is_a?(Proc)
        Exporter.format field.call(item)
      elsif field =~ /(.+)_id$/
        Exporter.format item.send(Regexp.last_match(1))
      elsif field =~ /(.+)_ids$/
        item.send(Regexp.last_match(1)).map do |f|
          Exporter.format f
        end.join('; ')
      elsif field.in? %w[status state]
        I18n.t(item.send(field), scope: field.to_sym)
      elsif item.is_a?(Hash)
        Exporter.format item[field]
      else
        Exporter.format item.send(field)
      end
    end

    def self.format(val)
      val = Time.zone.parse(val) if val.is_a?(String) && val =~ /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/

      if val.is_a?(ActiveRecord::Base)
        val.try(:to_s)
      elsif val.is_a? Time
        I18n.l(val, format: :compact)
      elsif val.is_a? Date
        I18n.l(val, format: :default)
      elsif val.is_a? BigDecimal
        val.to_f
      elsif val.is_a?(FalseClass) || val.is_a?(TrueClass)
        I18n.t(val ? 'yes' : 'no')
      elsif val.nil?
        '-'
      else
        val
      end
    end
  end
end
