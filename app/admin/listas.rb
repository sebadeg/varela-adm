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

  permit_params :id, :nombre, :anio, :sector_id, :locale, 
    lista_alumno_attributes: [:id,:lista_id,:alumno_id,:_destroy,:locale]

  menu priority: 1, label: "Listas", parent: "Secretaría"


  member_action :copiar, method: :put do
    id = params[:id]
    lista = Lista.find(id)

    lista_copia = Lista.create(nombre: "#{lista.nombre} Copia" )
    p lista_copia
    ListaAlumno.where(lista_id: lista.id).each do |lista_alumno|
      ListaAlumno.create(lista_id: lista_copia.id, alumno_id: lista_alumno.alumno_id)
    end

    redirect_to admin_listas_path, notice: "Hecho!"
  end

  index do
    #selectable_column
    column :nombre
    actions defaults: false do |u|
      item "Ver", admin_lista_path(u), class: "view_link member_link", title: "Ver"
      item "Copiar", copiar_admin_lista_path(u), class: "member_link", method: :put, title: "Copiar"
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
      f.input :sector_id, :input_html => { :value => UsuarioSector.where(admin_usuario_id: current_admin_usuario.id).order(:indice).first.sector_id }, as: :hidden
    end
    f.inputs do
      f.has_many :lista_alumno, heading: "Alumnos", allow_destroy: true, new_record: true do |l|
        l.input :alumno_id, :label => "Nombre", :as => :select, :collection => Alumno.where("id IN (SELECT alumno_id FROM sector_alumnos WHERE sector_id IN (SELECT sector_id FROM usuario_sectores WHERE admin_usuario_id=#{current_admin_usuario.id}) AND anio IN (SELECT anio FROM configs WHERE NOT anio IS NULL))").order(:nombre,:apellido).map{|u| [u.nombre + " " + u.apellido, u.id]}
      end
    end
    f.actions
  end

  controller do

    def show
      @page_title = "Lista: "+ resource.nombre
    end

    def edit
      @page_title = "Lista: "+ resource.nombre
    end
  end

end
