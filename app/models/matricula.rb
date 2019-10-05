class Matricula < ApplicationRecord
  has_many :matricula_opcion, :dependent => :delete_all
  accepts_nested_attributes_for :matricula_opcion, allow_destroy: true
end
