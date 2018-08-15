ActiveAdmin.register Contrato do
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

  permit_params :nombre, :cuenta_id, :alumno_id, :concepto_id,
      contrato_cuota_attributes: [:id,:contrato_id,:fecha,:precio,:descuento,:_destroy]

  menu priority: 31, label: "Contrato"

  action_item :actualizar, only: :show do
    link_to "Actualizar", actualizar_admin_contrato_path(contrato), method: :put 
  end

  action_item :actualizarfunc, only: :show do
    link_to "Actualizar Func", actualizarfunc_admin_contrato_path(contrato), method: :put 
  end

  member_action :actualizar, method: :put do
    id = params[:id]

    cc = ContratoCuota.where(["contrato_id=? AND fecha='2018-07-01'",id]).first!

    ContratoCuota.where(["contrato_id=? AND fecha>'2018-07-01'",id]).each do |x|
      x.precio = cc.precio
      x.descuento = cc.descuento
      x.save!
    end

    contrato = Contrato.find(id.to_i+1)
    redirect_to admin_contrato_path(contrato)
  end

  member_action :actualizarfunc, method: :put do
    id = params[:id]

    cc = ContratoCuota.where(["contrato_id=? AND fecha='2018-07-01'",id]).first!
    ContratoCuota.where(["contrato_id=? AND fecha>'2018-07-01' AND fecha<'2018-12-01'",id]).each do |x|
      x.precio = cc.precio
      x.descuento = cc.descuento
      x.save!
    end

    ContratoCuota.where(["contrato_id=? AND fecha='2018-12-01'",id]).each do |x|
      x.precio = (cc.precio*1.5).round(0)
      x.descuento = (cc.descuento*1.5).round(0)
      x.save!
    end

    # ActiveRecord::Base.connection.execute( "DELETE FROM actividad_alumnos WHERE actividad_id=#{id};" )
    # ActiveRecord::Base.connection.execute( "INSERT INTO actividad_alumnos (actividad_id,alumno_id,created_at,updated_at) (SELECT #{id},id,now(),now() FROM alumnos WHERE id IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT lista_id FROM actividad_listas WHERE actividad_id=#{id})));" )

    contrato = Contrato.find(id.to_i+1)
    redirect_to admin_contrato_path(contrato)
  end

  index do
    #selectable_column
    column :id
    column :cuenta_id
    column :alumno_id
    column :concepto_id
    actions
  end

  filter :cuenta_id

  show do |r|
    attributes_table do
      row :id
      row :cuenta_id
      row :alumno_id
      row :concepto_id
      row "Cuotas" do 
        table_for ContratoCuota.where("contrato_id=#{r.id}").order(:fecha) do |t|
          t.column :fecha
          t.column :precio
          t.column :descuento
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :cuenta_id
      f.input :alumno_id
      f.input :concepto_id
    end
    f.inputs do
      f.has_many :contrato_cuota, heading: "Cuotas", allow_destroy: true, new_record: true do |l|
        l.input :fecha
        l.input :precio
        l.input :descuento
      end
    end
    f.actions
  end

  # controller do

  #   def create
  #     attrs = permitted_params[:actividad]
      
  #     actividad = Actividad.create()
  #     actividad.importar(attrs)

  #     if attrs[:archivo] != nil
  #       params[:actividad][:archivo] = actividad.archivo
  #     end

  #     i = 0
  #     begin
  #       if params[:actividad][:actividad_opcion_attributes] == nil || params[:actividad][:actividad_opcion_attributes][i.to_s] == nil
  #         i = -1
  #       else 
  #         if params[:actividad][:actividad_opcion_attributes][i.to_s][:id] == nil
  #           actividad_id = params[:id].to_i
  #           valor = params[:actividad][:actividad_opcion_attributes][i.to_s][:valor]
  #           opcion = params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion]
  #           eleccion = params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion]

  #           ActiveRecord::Base.connection.execute( "INSERT INTO actividad_opciones (actividad_id,valor,opcion,eleccion,created_at,updated_at) VALUES (#{actividad_id},#{valor},'#{opcion}','#{eleccion}',now(),now())" )
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:id] = ActividadOpcion.where("actividad_id=#{actividad_id} AND valor=#{valor}").first.id.to_s
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:valor] = valor
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion] = opcion
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion] = eleccion
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:_destroy] = "0"
  #         end
  #         i = i+1
  #       end
  #     end while i >= 0

  #     i = 0
  #     begin
  #       if params[:actividad][:actividad_lista_attributes][i.to_s] == nil
  #         i = -1
  #       else 
  #         if params[:actividad][:actividad_lista_attributes][i.to_s][:id] == nil
  #           p params[:id].to_i
  #           p params[:actividad][:actividad_lista_attributes][i.to_s][:alumno_id].to_i
  #           actividad_id = actividad.id
  #           lista_id = params[:actividad][:actividad_lista_attributes][i.to_s][:lista_id].to_i
  #           ActiveRecord::Base.connection.execute( "INSERT INTO actividad_listas (actividad_id,lista_id,created_at,updated_at) VALUES (#{actividad_id},#{lista_id},now(),now())" )
  #           params[:actividad][:actividad_lista_attributes][i.to_s][:id] = ActividadLista.where("actividad_id=#{actividad_id} AND lista_id=#{lista_id}").first.id.to_s
  #           params[:actividad][:actividad_lista_attributes][i.to_s][:_destroy] = "0"
  #         end
  #         i = i+1
  #       end
  #     end while i >= 0
  #     redirect_to admin_actividad_path(actividad)
  #   end

  #   def update
  #     attrs = permitted_params[:actividad]

  #     actividad = Actividad.where(id:params[:id]).first!
  #     actividad.importar(attrs)

  #     if attrs[:archivo] != nil
  #       params[:actividad][:archivo] = actividad.archivo
  #     end


  #     i = 0
  #     begin
  #       if params[:actividad][:actividad_opcion_attributes] == nil || params[:actividad][:actividad_opcion_attributes][i.to_s] == nil
  #         i = -1
  #       else 
  #         if params[:actividad][:actividad_opcion_attributes][i.to_s][:id] == nil
  #           actividad_id = params[:id].to_i
  #           valor = params[:actividad][:actividad_opcion_attributes][i.to_s][:valor]
  #           opcion = params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion]
  #           eleccion = params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion]

  #           ActiveRecord::Base.connection.execute( "INSERT INTO actividad_opciones (actividad_id,valor,opcion,eleccion,created_at,updated_at) VALUES (#{actividad_id},#{valor},'#{opcion}','#{eleccion}',now(),now())" )
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:id] = ActividadOpcion.where("actividad_id=#{actividad_id} AND valor=#{valor}").first.id.to_s
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:valor] = valor
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion] = opcion
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion] = eleccion
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:_destroy] = "0"
  #         end
  #         i = i+1
  #       end
  #     end while i >= 0

  #     i = 0
  #     begin
  #       if params[:actividad][:actividad_lista_attributes][i.to_s] == nil
  #         i = -1
  #       else 
  #         if params[:actividad][:actividad_lista_attributes][i.to_s][:id] == nil
  #           p params[:id].to_i
  #           p params[:actividad][:actividad_lista_attributes][i.to_s][:alumno_id].to_i
  #           actividad_id = params[:id].to_i
  #           lista_id = params[:actividad][:actividad_lista_attributes][i.to_s][:lista_id].to_i
  #           ActiveRecord::Base.connection.execute( "INSERT INTO actividad_listas (actividad_id,lista_id,created_at,updated_at) VALUES (#{actividad_id},#{lista_id},now(),now())" )
  #           params[:actividad][:actividad_lista_attributes][i.to_s][:id] = ActividadLista.where("actividad_id=#{actividad_id} AND lista_id=#{lista_id}").first.id.to_s
  #           params[:actividad][:actividad_lista_attributes][i.to_s][:_destroy] = "0"
  #         end
  #         i = i+1
  #       end
  #     end while i >= 0

  #     update!
  #   end
    
  # end

end
