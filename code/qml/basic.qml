import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

ApplicationWindow {
  title: "My Application"; width: 200; height: 150; visible: true
  
  ColumnLayout {
    anchors.centerIn: parent

    Text { text: "Enter a number:" }

    TextField {
      id: input
      Layout.alignment: Qt.AlignCenter
      width: 100
      onTextChanged: {
        x = parseInt(text);
        if(!isNaN(x)) {
          juliaproperties.input = x;
        }
      }
      Component.onCompleted: { text = juliaproperties.input }
    }

    Text { text: "The double is: " + juliaproperties.output }

    Button {
      text: "Reset"
      onClicked: {
        Julia.reset_input();
        input.text = juliaproperties.input
      }
    }
  }
}