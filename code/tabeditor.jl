using QML, Observables, DataFrames, CSV

qml_file = joinpath(@__DIR__, "qml", "tabeditor.qml")

const datapath = joinpath(pkgdir(DataFrames), "docs", "src", "assets")
const juliaproperties = JuliaPropertyMap(
  "datapath" => datapath,
  "tablemodel" => JuliaItemModel(DataFrame()),
)

loadeddataframe = DataFrame()

function getheader(df::DataFrame, col_or_row, orientation, role)
  if orientation == QML.Vertical
    return col_or_row
  end
  return names(df)[col_or_row]
end

function setheader(df::DataFrame, col_or_row, orientation, value, role)
  if orientation == QML.Horizontal
    rename!(df, names(df)[col_or_row] => value)
  end
end

function setelement(df::DataFrame, value::AbstractString, row, col)
  dt = typeof(df[row,col])
  if dt <: AbstractString
    df[row,col] = value
  else
    df[row,col] = parse(dt, value)
  end
end

function QML.insert_row!(m::QML.ItemModelData{DataFrame}, rowidx, row::AbstractVector{QVariant})
  df = m.values[]
  insert!(df, rowidx, df[rowidx,:])
  return
end

function QML.insert_column!(m::QML.ItemModelData{DataFrame}, columnidx, column::AbstractVector{QVariant})
  df = m.values[]
  insertcols!(df,columnidx,(names(df)[columnidx]*"Copy" => df[!,columnidx]))
  return
end

urltopath(filename) = String(QML.toString(filename)[8:end])

function loaddataframe(filename)
  global loadeddataframe = DataFrame(CSV.File(urltopath(filename);stringtype=String))
  model = JuliaItemModel(loadeddataframe)
  setheadergetter!(model, getheader)
  setheadersetter!(model, setheader)
  setsetter!(model, setelement, QML.EditRole)
  juliaproperties["tablemodel"] = model
  return
end

savedataframe(filename) = CSV.write(urltopath(filename), loadeddataframe)

@qmlfunction loaddataframe savedataframe

engine = loadqml(qml_file; juliaproperties)
watchqml(engine, qml_file)
exec()
