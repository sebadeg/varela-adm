# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_23_170000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "actividad_alumnos", id: :serial, force: :cascade do |t|
    t.integer "actividad_id"
    t.integer "alumno_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "opcion"
    t.date "fecha"
    t.boolean "secretaria"
    t.boolean "mail"
    t.index ["actividad_id"], name: "index_actividad_alumnos_on_actividad_id"
    t.index ["alumno_id"], name: "index_actividad_alumnos_on_alumno_id"
  end

  create_table "actividad_archivos", force: :cascade do |t|
    t.bigint "actividad_id"
    t.string "nombre"
    t.binary "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actividad_id"], name: "index_actividad_archivos_on_actividad_id"
  end

  create_table "actividad_listas", id: :serial, force: :cascade do |t|
    t.integer "actividad_id"
    t.integer "lista_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actividad_id"], name: "index_actividad_listas_on_actividad_id"
    t.index ["lista_id"], name: "index_actividad_listas_on_lista_id"
  end

  create_table "actividad_opciones", id: :serial, force: :cascade do |t|
    t.integer "actividad_id"
    t.integer "valor"
    t.string "opcion"
    t.string "eleccion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cuotas"
    t.decimal "importe"
    t.date "fecha"
    t.string "concepto"
    t.index ["actividad_id"], name: "index_actividad_opciones_on_actividad_id"
  end

  create_table "actividades", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "descripcion"
    t.string "archivo"
    t.date "fecha"
    t.date "fechainfo"
    t.binary "data"
  end

  create_table "admin_usuarios", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "soporte", default: false
    t.boolean "primaria", default: false
    t.boolean "sec_mdeo", default: false
    t.boolean "sec_cc", default: false
    t.boolean "administracion", default: false
    t.boolean "inscripciones"
    t.index ["email"], name: "index_admin_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_usuarios_on_reset_password_token", unique: true
  end

# Could not dump table "alumnos" because of following ActiveRecord::StatementInvalid
#   PG::ConnectionBad: PQconsumeInput() server closed the connection unexpectedly
	This probably means the server terminated abnormally
	before or while processing the request.
: SELECT a.attname
  FROM (
         SELECT indrelid, indkey, generate_subscripts(indkey, 1) idx
           FROM pg_index
          WHERE indrelid = '"alumnos"'::regclass
            AND indisprimary
       ) i
  JOIN pg_attribute a
    ON a.attrelid = i.indrelid
   AND a.attnum = i.indkey[i.idx]
 ORDER BY i.idx

