import QtQuick 6.7
import QtQuick.Controls 6.7
import QtQuick.Layouts
import QtQuick.Dialogs
import org.julialang

ApplicationWindow {
    title: "Table Editor"
    width: 640
    height: 480
    visible: true
    x: 1000
    y: 200

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent

        RowLayout {
            id: rowLayout
            width: 100
            height: 100

            Button {
                id: button
                text: qsTr("Load")
                onClicked: loadDialog.open()
            }

            Button {
                id: button1
                text: qsTr("Save")
                onClicked: saveDialog.open()
            }
        }

        RowLayout {
            id: rowLayout1

            Item {
                id: tablePane
                Layout.fillHeight: true
                Layout.fillWidth: true

                HorizontalHeaderView {
                    id: horizontalHeader
                    syncView: tableView
                    anchors.left: tableView.left
                    clip: true
                    selectionModel: ItemSelectionModel {}
                    selectionBehavior: TableView.SelectCells
                    editTriggers: TableView.DoubleTapped
                    delegate: Item {
                        implicitWidth: 100
                        implicitHeight: delegateText.implicitHeight+2

                        TextField {
                            id: delegateText
                            anchors.fill: parent
                            text: display
                            horizontalAlignment: TextInput.AlignHCenter
                            verticalAlignment: TextInput.AlignVCenter
                            onAccepted: {
                                edit = text
                            }
                        }
                    }
                }

                VerticalHeaderView {
                    id: verticalHeader
                    syncView: tableView
                    anchors.top: tableView.top
                    clip: true
                }

                TableView {
                    id: tableView

                    anchors.fill: parent
                    anchors.topMargin: horizontalHeader.height
                    anchors.leftMargin: verticalHeader.width

                    columnSpacing: 1
                    rowSpacing: 1
                    clip: true

                    model: juliaproperties.tablemodel
                    selectionModel: ItemSelectionModel {}

                    delegate: Rectangle {
                        implicitWidth: 100
                        implicitHeight: delegateText.implicitHeight+2
                        required property bool selected
                        required property bool current
                        border.width: current ? 2 : 0
                        color: selected ? "lightblue" : palette.base

                        Text {
                            id: delegateText
                            anchors.centerIn: parent
                            text: display
                        }

                        TableView.editDelegate: TextField {
                            anchors.fill: parent
                            text: display
                            horizontalAlignment: TextInput.AlignHCenter
                            verticalAlignment: TextInput.AlignVCenter
                            Component.onCompleted: selectAll()

                            TableView.onCommit: {
                                edit = text
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        id: vbar
                        visible: tableView.moving
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: vbar.visible = true
                            onExited: vbar.visible = false
                        }
                    }
                    ScrollBar.horizontal: ScrollBar {
                        id: hbar
                        visible: tableView.moving
                        MouseArea {
                            anchors.fill: parent
                            onEntered: hbar.visible = true
                            onExited: hbar.visible = false
                        }
                    }
                }
            }

            ColumnLayout {
                id: columnLayout1
                width: 100
                height: 100

                Button {
                    id: button2
                    Layout.preferredWidth: 130
                    text: qsTr("Insert row")
                    onClicked: juliaproperties.tablemodel.insertRow(tableView.currentRow,[])
                }

                Button {
                    id: button3
                    Layout.preferredWidth: 130
                    text: qsTr("Delete row")
                    onClicked: juliaproperties.tablemodel.removeRow(tableView.currentRow);
                }

                Button {
                    id: button4
                    text: qsTr("Insert column")
                    onClicked: juliaproperties.tablemodel.insertColumn(tableView.currentColumn,[])
                }

                Button {
                    id: button5
                    text: qsTr("Delete column")
                    onClicked: juliaproperties.tablemodel.removeColumn(tableView.currentColumn);
                }
            }
        }
    }

    FileDialog {
        id: loadDialog
        title: "Load CSV..."
        currentFolder: Qt.resolvedUrl(juliaproperties.datapath)
        onAccepted: Julia.loaddataframe(selectedFile)
    }

    FileDialog {
        id: saveDialog
        title: "Save CSV..."
        fileMode: FileDialog.SaveFile
        onAccepted: Julia.savedataframe(selectedFile)
    }
}
