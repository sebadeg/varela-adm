# ActiveAdmin.register Recibo do

#   menu label: 'Recibos', priority: 22 

#   permit_params :id,:cuenta_id,:nombre,:fecha,:importe,:suma,:concepto,:cheque,:banco,:fecha_vto,:hoja_nro

#   action_item :imprimir, only: :show do
#     link_to "Imprimir", imprimir_admin_recibo_path(recibo), method: :put 
#   end

#   member_action :imprimir, method: :put do
#     id = params[:id]
#     recibo = Recibo.find(id)
  
#     file_name = "Recibo #{recibo.id}.pdf"
#     file = Tempfile.new(file_name)
#     recibo.imprimir(file.path)

#     send_file(
#         file.path,
#         filename: file_name,
#         type: "application/pdf"
#       )
    
#   end

#   index do
#   	#selectable_column
#     column :id
#     column :cuenta_id
#     column :nombre
#     column :fecha
#     column :importe

#     column :suma    
#     column :concepto
#     column :cheque
#     column :banco
#     column :fecha_vto    
#     column :hoja_nro

#     actions
#   end

#   filter :id
#   filter :nombre

#   show do
#     attributes_table do
#       row :id
#       row :cuenta_id
#       row :nombre
#       row :fecha
#       row :importe
#       row :suma    
#       row :concepto
#       row :cheque
#       row :banco
#       row :fecha_vto    
#       row :hoja_nro
#     end
#   end

#   form do |f|
#     f.inputs do
#       f.input :id
#       f.input :cuenta_id
#       f.input :nombre
#       f.input :fecha
#       f.input :importe
#       f.input :suma    
#       f.input :concepto
#       f.input :cheque
#       f.input :banco
#       f.input :fecha_vto    
#       f.input :hoja_nro
#     end
#     f.actions
#   end

# end
