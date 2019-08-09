ActiveAdmin.register Actividad, :as => 'Autorizar' do

  menu false  

  form partial: 'form'

  controller do
    def edit
      @page_title = "Autorizar Actividad"
    end
  end

end
