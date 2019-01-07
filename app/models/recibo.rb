class Recibo < ApplicationRecord

    def fecha_tos(fecha)
      if ( fecha == nil )
        return ""
      end
      return I18n.l(fecha, format: '%-d de %B de %Y')
    end

    def imprimir(file_path)

      recibo = Recibo.find(id)

      text_file = Tempfile.new("text.pdf")
      text_file_path = text_file.path


      f_vto = fecha_tos(recibo.fecha_vto)

      Prawn::Document.generate(text_file_path) do
      	
        # stroke_color "000000"
        # stroke_rectangle [0, 720], 540, 190
        # stroke_rectangle [0, 455], 540, 190
        # stroke_rectangle [0, 190], 540, 190

        dash(0.25, :space => 0.25, :phase => 0)
        stroke_horizontal_line 0, 540, :at => 492
        stroke_horizontal_line 0, 540, :at => 227

        [0,265,530].each do |x|
      
          font "Helvetica", :size => 5

          image Rails.root.join("data", "logo.png"), at: [44,x+190], scale: 0.066

          bounding_box([0, x+170], :width => 105, :height => 5) do
            text "Sociedad Uruguaya de Enseñanza", align: :center, inline_format: true
          end
          bounding_box([0, x+162], :width => 105, :height => 5) do
            text "COLEGIO NACIONAL JOSÉ PEDRO VARELA", align: :center, inline_format: true
          end

          font "Helvetica", :size => 8

          bounding_box([0, x+67], :width => 135, :height => 10) do
            text "Cheque Nro. #{recibo.cheque}", align: :left, inline_format: true
          end

          bounding_box([135, x+67], :width => 135, :height => 10) do
            text "Banco #{recibo.banco}", align: :left, inline_format: true
          end

          bounding_box([270, x+67], :width => 135, :height => 10) do
            text "Vto. #{f_vto}", align: :left, inline_format: true
          end

          bounding_box([405, x+67], :width => 135, :height => 10) do
            text "$ #{recibo.importe}", align: :left, inline_format: true
          end

          font "Helvetica", :size => 10

          bounding_box([460, x+10], :width => 80, :height => 10) do
            text "N° #{recibo.hoja_nro}" , align: :right, inline_format: true
          end
        end

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
