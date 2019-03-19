ActiveAdmin.register_page "Ver_Movimiento" do

  menu priority: 5, label: "Vista previa", parent: "Cuenta Corriente"

  page_action :ver, method: :post do
    Temp.create(usuario_id: current_admin_usuario.id, temp_id: params[:cuenta_id] )
    redirect_to admin_ver_movimiento_path
  end

  content title: "Vista previa" do
    temp = Temp.where("usuario_id = #{current_admin_usuario.id}").order(id: :desc).limit(1).first rescue nil
    if temp == nil 
      render partial: 'ver_movimiento', locals: { cuenta_id: nil, usuario_id: current_admin_usuario.id }
    else
      render partial: 'ver_movimiento', locals: { cuenta_id: temp.temp_id, usuario_id: current_admin_usuario.id }
    end
  end

end