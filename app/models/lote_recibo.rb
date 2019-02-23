class LoteRecibo < ApplicationRecord
	belongs_to :cuenta
	
    def imprimir(file_path)
    end


end
