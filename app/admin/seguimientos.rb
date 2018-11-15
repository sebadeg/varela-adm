ActiveAdmin.register Seguimiento do

  menu label: 'Seguimiento'
  menu parent: 'Seguimiento'

  permit_params :id, :alumno_id, :celular, :no_atiende, :no_inscribe, :inscribe, :duda, :comentario, :created_at, :updated_at

  index do
  	#selectable_column
    column :alumno_id
    column :created_at

    actions
  end

  filter :alumno_id

  show do
    attributes_table do
      row :alumno_id
      row :celular
      row :no_atiende
      row :no_inscribe
      row :inscribe
      row :duda
      row :comentario
    end
  end

  form do |f|

    s = ""
    if $alumno_id != nil
      Usuario.where("id IN (SELECT usuario_id FROM titular_cuentas WHERE cuenta_id IN (SELECT cuenta_id FROM cuenta_alumnos WHERE alumno_id=#{$alumno_id}))").each do |u|
        if s != ""
          s = s + " - "
        end
        s = s + "#{u.nombre} #{u.apellido} (#{u.celular})"
      end
    end

    f.inputs do
      f.li s, label: "Registrado"
      f.input :alumno_id

      f.input :celular
      f.input :no_atiende
      f.input :no_inscribe
      f.input :inscribe
      f.input :duda
      f.input :comentario
    end
    f.actions
  end

  controller do

    def build_new_resource
      r = super
      r.assign_attributes(alumno_id: $alumno_id)
      r
    end

    def index
      $alumno_id = nil
      if params["q"] != nil
        $alumno_id = params["q"]["alumno_id_equals"]
      end
      super
    end 

    def new
      if $alumno_id != nil
        alumno = Alumno.find($alumno_id)
        @page_title = "Añadir seguimiento a #{alumno.nombre} #{alumno.apellido}"
      end
      new!
    end

  end

end
