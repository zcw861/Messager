/**
* @file    SettingDialog.qml
* @date    2026-08-12
* @author  JiangFan
* @brief   设置窗口
*
* Version: 0.1.0
* License: AGPLv3
* Created:  JiangFan 2026-08-14
*
*
* Change Log:
* [v0.1.0]  JiangFan  2026-08-12
* * Initial creation
* [v0.2.0]  JiangFan  2026-08-14
* * 框架已经完成，内容已经填写大半。
* [v0.2.1]  zhouChengWei  2026-08-18
* * 修改了悬停时间。
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Dialog {
    id: settingsDialog

    required property var appController

    modal: true
    focus: true

    width: 700
    height: 500

    //当前左侧选中的设置分类
    property int currentSettingIndex: 0

    title: qsTr("设置")

    background: Rectangle {
        color: "#FFFFFF"
        radius: 10

        border.color: "#D9D9D9"
        border.width: 1
    }

    contentItem: ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 0

            //左侧设置分类
            Rectangle {
                Layout.preferredWidth: 150
                Layout.fillHeight: true

                color: "#F5F5F5"

                ListView {
                    anchors.fill: parent
                    anchors.margins: 8

                    spacing: 4

                    model: [
                        {
                            "title": qsTr("存储管理"),
                            "icon": "source/saveManager.svg"
                        },
                        {
                            "title": qsTr("App信息"),
                            "icon": "source/information.svg"
                        }

                    ]

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        width: ListView.view.width
                        height: 42

                        radius: 6

                        color: settingsDialog.currentSettingIndex === index
                               ? "#E8F3FF"
                               : categoryHover.hovered
                                 ? "#EAEAEA"
                                 : "transparent"

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            anchors.verticalCenter: parent.verticalCenter

                            spacing: 10

                            //设置分类图标
                            Image {
                                width: 18
                                height: 18

                                anchors.verticalCenter: parent.verticalCenter

                                source: modelData.icon
                                fillMode: Image.PreserveAspectFit
                            }

                            //设置分类名称
                            Text {
                                anchors.verticalCenter: parent.verticalCenter

                                text: modelData.title

                                color: "#333333"
                                font.pixelSize: 14
                            }
                        }

                        HoverHandler {
                            id: categoryHover

                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            acceptedButtons: Qt.LeftButton
                            gesturePolicy: TapHandler.ReleaseWithinBounds

                            onTapped: {
                                settingsDialog.currentSettingIndex = index
                            }
                        }
                    }
                }
            }

            //右侧具体设置内容
            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                currentIndex: settingsDialog.currentSettingIndex

                //文件设置页
                Item {
                    ColumnLayout {
                        anchors.fill: parent

                        spacing: 18

                        //设置右边的界面的大标题
                        Text {
                                text: qsTr("文件")

                                color: "#222222"

                                Layout.topMargin: 5
                                Layout.leftMargin: 5
                                font.pixelSize: 18
                                font.bold: true
                            }

                        //分割线
                        Rectangle {
                            color: "#9d9d9d"

                            height: 1
                            Layout.topMargin: 1
                            Layout.fillWidth: true
                        }

                        //默认文件保存路径
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 90

                            radius: 8

                            color: "#F8F8F8"

                            border.color: "#E2E2E2"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16

                                spacing: 12

                                ColumnLayout {
                                    Layout.fillWidth: true

                                    spacing: 6

                                    Text {
                                        text: qsTr("默认文件保存位置")

                                        color: "#333333"
                                        font.pixelSize: 14
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: settingsDialog.appController.defaultDownloadPath

                                        color: "#777777"
                                        font.pixelSize: 12

                                        elide: Text.ElideMiddle
                                    }
                                }

                                Button {
                                    text: qsTr("更改")

                                    onClicked: {
                                        defaultDownloadFolderDialog.currentFolder =
                                            settingsDialog.appController.localFileUrl(
                                                settingsDialog.appController.defaultDownloadPath
                                            )

                                        defaultDownloadFolderDialog.open()
                                    }
                                }
                            }
                        }

                        //缓存目录
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 90

                            radius: 8

                            color: "#F8F8F8"

                            border.color: "#E2E2E2"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16

                                spacing: 6

                                Text {
                                    text: qsTr("缓存位置")

                                    color: "#333333"
                                    font.pixelSize: 14
                                }

                                Text {
                                    Layout.fillWidth: true

                                    text: settingsDialog.appController.cachePath

                                    color: "#777777"
                                    font.pixelSize: 12

                                    elide: Text.ElideMiddle
                                }

                                Text {
                                    text: qsTr("暂不支持修改")

                                    color: "#A0A0A0"
                                    font.pixelSize: 11
                                }
                            }
                        }

                        Item {
                            Layout.fillHeight: true
                        }
                    }
                }

                //App信息页
                Item {
                    ScrollView {
                        id: appInfoScrollView

                        anchors.fill: parent
                        clip: true

                        //只允许上下滚动，不允许左右滚动
                        contentWidth: availableWidth

                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                        ColumnLayout {
                            //内容宽度始终限制在ScrollView内部，避免文字把整个页面横向撑出去
                            width: appInfoScrollView.availableWidth

                            spacing: 16

                            //大标题
                            Text {
                                Layout.leftMargin: 5
                                Layout.topMargin: 5

                                text: qsTr("App 信息")

                                color: "#222222"
                                font.pixelSize: 18
                                font.bold: true
                            }

                            //分割线
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 1

                                color: "#9D9D9D"
                            }

                            //信息内容
                            ColumnLayout {
                                Layout.fillWidth: true

                                Layout.leftMargin: 20
                                Layout.rightMargin: 20
                                Layout.topMargin: 10
                                Layout.bottomMargin: 20

                                spacing: 16

                                //软件名称
                                Text {
                                    text: qsTr("Messager")

                                    color: "#222222"
                                    font.pixelSize: 22
                                    font.bold: true
                                }

                                Text {
                                    Layout.fillWidth: true

                                    text: qsTr("局域网即时通信与文件传输应用")

                                    color: "#777777"
                                    font.pixelSize: 13

                                    wrapMode: Text.Wrap
                                }

                                //软件信息
                                Text {
                                    Layout.topMargin: 10

                                    text: qsTr("软件信息")

                                    color: "#333333"
                                    font.pixelSize: 15
                                    font.bold: true
                                }

                                GridLayout {
                                    Layout.fillWidth: true

                                    columns: 2

                                    columnSpacing: 30
                                    rowSpacing: 10

                                    Text {
                                        Layout.preferredWidth: 70

                                        text: qsTr("开发时间")
                                        color: "#777777"
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: qsTr("2026.06 - 2026.08")
                                        color: "#333333"

                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        Layout.preferredWidth: 70

                                        text: qsTr("软件定位")
                                        color: "#777777"
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: qsTr("局域网桌面即时通信应用")
                                        color: "#333333"

                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        Layout.preferredWidth: 70

                                        text: qsTr("软件作用")
                                        color: "#777777"
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: qsTr(
                                            "面向局域网环境提供用户发现、私聊、群聊、图片消息和普通文件传输等功能。"
                                        )

                                        color: "#333333"

                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        Layout.preferredWidth: 70

                                        text: qsTr("指导老师")
                                        color: "#777777"
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: qsTr("龚伟")
                                        color: "#333333"

                                        wrapMode: Text.Wrap
                                    }
                                }

                                //开发者
                                Text {
                                    Layout.topMargin: 10

                                    text: qsTr("开发者")

                                    color: "#333333"
                                    font.pixelSize: 15
                                    font.bold: true
                                }

                                RowLayout {
                                    Layout.fillWidth: true

                                    spacing: 15

                                    Text {
                                        id: jiangFanText

                                        text: qsTr("江钒")

                                        color: jiangFanHover.hovered
                                               ? "#029AFF"
                                               : "#333333"

                                        font.pixelSize: 15

                                        HoverHandler {
                                            id: jiangFanHover

                                            cursorShape: Qt.PointingHandCursor

                                            onHoveredChanged: {
                                                if (hovered) {
                                                    //鼠标进入姓名后开始0.5秒计时
                                                    developerCardShowTimer.restart()

                                                    //如果正在等待关闭，则取消关闭
                                                    developerCardCloseTimer.stop()
                                                }
                                                else {
                                                    //还没到0.5秒就离开，则不会显示名片
                                                    developerCardShowTimer.stop()

                                                    //给鼠标留一点时间从姓名移动到名片
                                                    developerCardCloseTimer.restart()
                                                }
                                            }
                                        }
                                    }

                                    Text {
                                        id: zhouChengWeiText
                                        text: qsTr("周城伟")
                                        color: "#333333"
                                        font.pixelSize: 15
                                    }

                                    Text {
                                        id: heZhiYuan
                                        text: qsTr("何志远")
                                        color: "#333333"
                                        font.pixelSize: 15
                                    }
                                }

                                //技术栈
                                Text {
                                    Layout.topMargin: 10

                                    text: qsTr("技术栈")

                                    color: "#333333"
                                    font.pixelSize: 15
                                    font.bold: true
                                }

                                GridLayout {
                                    Layout.fillWidth: true

                                    columns: 2

                                    columnSpacing: 30
                                    rowSpacing: 10

                                    Text {
                                        Layout.preferredWidth: 70

                                        text: qsTr("前端")
                                        color: "#777777"
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: qsTr(
                                            "Qt Quick / QML / Qt Quick Controls"
                                        )

                                        color: "#333333"

                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        Layout.preferredWidth: 70

                                        text: qsTr("后端")
                                        color: "#777777"
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: qsTr("C++ / Qt")
                                        color: "#333333"

                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        Layout.preferredWidth: 70

                                        text: qsTr("数据存储")
                                        color: "#777777"
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: qsTr("SQLite / QSettings")
                                        color: "#333333"

                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        Layout.preferredWidth: 70

                                        text: qsTr("网络通信")
                                        color: "#777777"
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: qsTr(
                                            "TCP / UDP / 文件传输"
                                        )

                                        color: "#333333"

                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        Layout.preferredWidth: 70

                                        text: qsTr("构建工具")
                                        color: "#777777"
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: qsTr("CMake / Ninja")
                                        color: "#333333"

                                        wrapMode: Text.Wrap
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    //开发者姓名悬停0.5秒后显示人物名片
    Timer {
        id: developerCardShowTimer

        interval: 500
        repeat: false

        onTriggered: {
            //计时结束时鼠标仍然停留在姓名上才显示
            if (!jiangFanHover.hovered) {
                return
            }

            //把姓名右侧位置转换到整个窗口Overlay坐标系，
            //保证Popup不会受到ScrollView裁剪
            const point = jiangFanText.mapToItem(
                Overlay.overlay,
                jiangFanText.width + 12,
                -20
            )

            developerCard.x = point.x
            developerCard.y = point.y

            developerCard.open()
        }
    }

    //鼠标离开姓名或名片后稍微延迟关闭，
    //避免从姓名移动到名片的过程中名片立即消失
    Timer {
        id: developerCardCloseTimer

        interval: 200
        repeat: false

        onTriggered: {
            if (!jiangFanHover.hovered
                && !developerCardHover.hovered) {

                developerCard.close()
            }
        }
    }

    //开发者人物名片
    Popup {
        id: developerCard

        parent: Overlay.overlay

        width: 330
        height: 140

        padding: 0

        modal: false
        focus: false

        //名片的打开与关闭完全由悬停逻辑控制
        closePolicy: Popup.NoAutoClose

        background: Rectangle {
            color: "#FFFFFF"

            radius: 10

            border.color: "#D9D9D9"
            border.width: 1
        }

        contentItem: RowLayout {
            spacing: 14

            //整个名片都可以检测鼠标是否仍在上面
            HoverHandler {
                id: developerCardHover

                onHoveredChanged: {
                    if (hovered) {
                        //鼠标成功从姓名移动到名片 --> 取消刚才准备执行的关闭操作
                        developerCardCloseTimer.stop()
                    }
                    else {
                        developerCardCloseTimer.restart()
                    }
                }
            }

            //左侧人物照片
            Rectangle {
                Layout.preferredWidth: 90
                Layout.preferredHeight: 110

                Layout.leftMargin: 14

                radius: 8

                color: "#EEEEEE"

                Image {
                    anchors.fill: parent

                    source: "source/jiangFan.jpg"

                    fillMode: Image.PreserveAspectCrop
                }
            }

            //右侧人物信息
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.topMargin: 14
                Layout.bottomMargin: 14
                Layout.rightMargin: 14

                spacing: 6

                Text {
                    text: qsTr("江钒")

                    color: "#222222"

                    font.pixelSize: 16
                    font.bold: true
                }

                Text {
                    text: qsTr("软件工程")

                    color: "#666666"
                    font.pixelSize: 12
                }

                Text {
                    Layout.fillWidth: true

                    text: qsTr("Messager 开发者")

                    color: "#666666"
                    font.pixelSize: 12

                    wrapMode: Text.Wrap
                }

                Text {
                    Layout.fillWidth: true

                    text: qsTr("负责文件传输、图片消息及相关功能开发。")

                    color: "#777777"
                    font.pixelSize: 11

                    wrapMode: Text.Wrap
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }

    //修改普通文件默认保存目录
    FolderDialog {
        id: defaultDownloadFolderDialog

        title: qsTr("选择默认文件保存位置")
        acceptLabel: qsTr("选择")

        onAccepted: {
            settingsDialog.appController.setDefaultDownloadPath(
                selectedFolder
            )
        }
    }
}
