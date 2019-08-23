# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'refinanciacion_cuota', 'refinanciacion_cuotas'
  inflect.irregular 'cuenta', 'cuentas'
  inflect.irregular 'titular_cuenta', 'titular_cuentas'
  inflect.irregular 'actividad', 'actividades'
  inflect.irregular 'opcion', 'opciones'
  inflect.irregular 'actividad_opcion', 'actividad_opciones'
  inflect.irregular 'lista', 'listas'
  inflect.irregular 'especial', 'especiales'
  inflect.irregular 'especial_cuenta', 'especial_cuentas'
  inflect.irregular 'contrato_cuota', 'contrato_cuotas'
  inflect.irregular 'inscripcion', 'inscripciones'
  inflect.irregular 'sector', 'sectores'
  inflect.irregular 'direccion', 'direcciones'
  inflect.irregular 'placta', 'plactas'
  inflect.irregular 'aactividad', 'aactividades'
  inflect.irregular 'aactividad_opcion', 'aactividad_opciones'
  inflect.irregular 'deudor', 'deudores'
  inflect.irregular 'movimiento2018', 'movimiento2018s'
  inflect.irregular 'usuario_sector', 'usuario_sectores'
  inflect.irregular 'refinanciacion', 'refinanciaciones'
end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
