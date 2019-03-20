ActiveAdmin.register Movimiento do

  config.sort_order = 'indice_asc'

  menu priority: 1, label: "Movimientos", parent: "Cuenta Corriente"

  index do
  	#selectable_column

    column "Fecha", :fecha, sortable: false
    column "Cuenta", :cuenta_id, sortable: false
    column "Alumno", :alumno, sortable: false
    column "Descripción", :descripcion, sortable: false
    column "Debe", :debe, sortable: false
    column "Haber", :haber, sortable: false
    column "Saldo", :saldo, sortable: false

    actions defaults: false do |u|
      item "Editar", edit_admin_lista_path(u), class: "edit_link member_link", title: "Editar" if u.fecha > DateTime.now
      item "Eliminar", admin_lista_path(u), class: "delete_link member_link", title:"Eliminar", "data-confirm": "¿Está seguro de que quiere eliminar esto?", rel: "nofollow", "data-method": :delete if u.fecha > DateTime.now
    end
  end

  filter :cuenta_id

  controller do    

    def index
      index! do |format|


        if params[:q] != nil && params[:q][:cuenta_id_equals] != nil
          i = 0
          s = 0
          Movimiento.where("cuenta_id=#{params[:q][:cuenta_id_equals]}").order(:fecha,:tipo,:id).each do |mov|
            s = s + mov.debe - mov.haber
            mov.update(saldo: s, indice: i)
            i = i + 1
          end
        end

        format.html
      end
    end

    #   if params[:cuenta_id_equals] != nil
    #     cuenta = params[:cuenta_id_equals].to_i
    #   end
  end

end
