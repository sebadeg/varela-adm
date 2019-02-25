ActiveAdmin.register Lista do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  permit_params :id, :nombre, :anio, :sector, :locale, 
    lista_alumno_attributes: [:id,:lista_id,:alumno_id,:_destroy,:locale]

  menu priority: 2001, label: "Listas"

  index do
    #selectable_column
    column :id
    column :nombre
    actions defaults: false do |u|
      item "Ver", admin_lista_path(u), class: "view_link member_link", title: "Ver"
      item "Editar", edit_admin_lista_path(u), class: "edit_link member_link", title: "Editar"
      item "Eliminar", admin_lista_path(u), class: "delete_link member_link", title:"Eliminar", "data-confirm": "¿Está seguro de que quiere eliminar esto?", rel: "nofollow", "data-method": :delete
    end
  end

  

  filter :nombre

  show do |r|
    attributes_table do
      row :nombre
      row "Alumnos" do 
        table_for Alumno.where("id in (SELECT alumno_id FROM lista_alumnos WHERE lista_id = #{r.id})").order(:nombre,:apellido) do |t|
          t.column :nombre
          t.column :apellido
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :anio, :input_html => { :value => Config.find(1).anio.to_s }, as: :hidden
      f.input :sector, :input_html => { :value => Alumno.sector_num(current_admin_usuario).to_s }, as: :hidden
    end
    f.inputs do
      f.has_many :lista_alumno, heading: "Alumnos", allow_destroy: true, new_record: true do |l|
        l.input :alumno_id, :label => "Nombre", :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| [u.nombre + " " + u.apellido, u.id]}
        #where("id IN (SELECT alumno_id FROM sector_alumnos WHERE sector_id IN (" + Alumno.sector(current_admin_usuario) + ") AND anio IN (SELECT anio FROM configs WHERE NOT anio IS NULL) AND NOT alumno_id IS NULL)").order(:nombre).map{|u| [u.nombre + " " + u.apellido, u.id]}
      end
    end
    f.actions
  end

  # controller do
  #   def update
  #     i = 0
  #     begin
  #       if params[:lista][:lista_alumno_attributes][i.to_s] == nil
  #         i = -1
  #       else 
  #         if params[:lista][:lista_alumno_attributes][i.to_s][:id] == nil

  #           p params[:id].to_i
  #           p params[:lista][:lista_alumno_attributes][i.to_s][:alumno_id].to_i
  #           lista_id = params[:id].to_i
  #           alumno_id = params[:lista][:lista_alumno_attributes][i.to_s][:alumno_id].to_i

  #           ActiveRecord::Base.connection.execute( "INSERT INTO lista_alumnos (lista_id,alumno_id,created_at,updated_at) VALUES (#{lista_id},#{alumno_id},now(),now())" )

  #           params[:lista][:lista_alumno_attributes][i.to_s][:id] = ListaAlumno.where("lista_id=#{lista_id} AND alumno_id=#{alumno_id}").first.id.to_s
  #           params[:lista][:lista_alumno_attributes][i.to_s][:_destroy] = "0"

     
  #         end
  #         i = i+1
  #       end
  #     end while i >= 0
  #     update!
  #   end 
  # end

end
