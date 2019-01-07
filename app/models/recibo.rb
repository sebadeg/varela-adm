class Recibo < ApplicationRecord

    def imprimir(file_path)

      text_file = Tempfile.new("text.pdf")
      text_file_path = text_file.path

      Prawn::Document.generate(text_file_path) do
      	font "Helvetica", :size => 10
      	
        stroke_color "000000"
        stroke_rectangle [0, 720], 540, 190
        stroke_rectangle [0, 455], 540, 190
        stroke_rectangle [0, 190], 540, 190

        dash(0.25, :space => 0.25, :phase => 0)
        stroke_horizontal_line 0, 540, :at => 492
        stroke_horizontal_line 0, 540, :at => 227
      
    #   stroke_color "FF0000"
    #   stroke_rectangle [2, 718], 536, 716

    #   image Rails.root.join("data", "logo.png"), at: [203,700], scale: 0.5

    #   bounding_box([20, 570], :width => 500, :height => 300) do
    #     text texto_inscripcion, align: :left, inline_format: true
    #   end

    #   bounding_box([20, 280], :width => 250, :height => 150) do
    #     text texto_padre, align: :left, inline_format: true
    #   end

    #   bounding_box([270, 280], :width => 250, :height => 150) do
    #     text texto_madre, align: :left, inline_format: true
    #   end

    #   bounding_box([20, 120], :width => 500, :height => 120) do
    #     text texto_nota, align: :justify, inline_format: true
    #   end

    # start_new_page

    #   font "Helvetica", :size => 10

    #   stroke_color "0000FF"
    #   stroke_rectangle [0, 720], 540, 720   
    #   stroke_color "FF0000"
    #   stroke_rectangle [2, 718], 536, 716

    #   bounding_box([20, 700], :width => 500, :height => 60) do
    #     text cabezal, align: :right, inline_format: true
    #   end
    #   bounding_box([20, 640], :width => 500, :height => 600) do
    #     text texto, align: :justify, inline_format: true
    #   end

      end

      pdf = CombinePDF.new
      pdf << CombinePDF.load(text_file_path)
      pdf.save file_path
      text_file.unlink

    end
end
