using QML, Observables

const input = Observable(0)
const output = Observable(0)

on(input) do x
  output[] = 2*x
end

reset_input() = (input[] = 0)
@qmlfunction reset_input

qml_file = joinpath(@__DIR__, "qml", "basic.qml")

loadqml(qml_file, juliaproperties = JuliaPropertyMap("input" => input, "output" => output))
exec()
println("Output is ", output[])