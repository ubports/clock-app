/*
 * Copyright (C) 2014-15 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Clock.Utility 1.0
import QtMultimedia 5.0
import Ubuntu.Content 1.1
import Ubuntu.Components 1.2

Page {
    id: _alarmSoundPage
    objectName: "alarmSoundPage"

    title: i18n.tr("Sound")
    flickable: _pageFlickable
    visible: false

    // Property to set the alarm sound in the edit alarm page
    property var alarmSound

    // Property to store the alarm object
    property var alarm

    // Property to set the alarm sound model in the edit alarm page
    property var soundModel

    property var customSoundModel

    /*
     Properties to store the previously set alarm sound values to detect
     if the user changed the alarm sound or not
    */
    property url oldAlarmSoundUrl
    property string oldAlarmSoundName

    property list<ContentItem> importItems
    property var activeTransfer
    property list<ContentPeer> peers

    Component.onCompleted: {
        // Record the current alarm sound values (url, name)
        oldAlarmSoundUrl = alarm.sound
        oldAlarmSoundName = alarmSound.subText
    }

    head.backAction: Action {
        iconName: "back"
        onTriggered: {
            // Restore alarm sound to old values (url, name) if the back button is pressed
            alarm.sound = oldAlarmSoundUrl
            alarmSound.subText = oldAlarmSoundName
            pop()
        }
    }

    head.actions: Action {
        id: saveAction
        objectName: "saveAction"
        iconName: "ok"
        enabled: oldAlarmSoundUrl !== alarm.sound
        onTriggered: {
            pop()
        }
    }

    ContentTransferHint {
        anchors.fill: parent
        activeTransfer: _alarmSoundPage.activeTransfer
    }

    Connections {
        target: _alarmSoundPage.activeTransfer
        onStateChanged: {
            if (_alarmSoundPage.activeTransfer.state === ContentTransfer.Charged) {
                _alarmSoundPage.importItems = _alarmSoundPage.activeTransfer.items
                console.log("[LOG] Original URL: " + _alarmSoundPage.importItems[0].url)
                _alarmSoundPage.importItems[0].move("/home/phablet/.local/share/com.ubuntu.clock")
                console.log("[LOG] Final URL: " + _alarmSoundPage.importItems[0].url)
            }
        }
    }

    Audio {
        id: previewAlarmSound
        audioRole: MediaPlayer.alert
    }

    FileManagement {
        id: fileManagement
    }

    StandardPath {
        id: standardPath
    }

    Flickable {
        id: _pageFlickable

        anchors.fill: parent
        contentHeight: soundModel.count * units.gu(7) + customSoundModel.count * units.gu(7) + customSoundListItem.height

        Column {
            id: _alarmSoundColumn

            anchors.fill: parent

            ListItem {
                id: customSoundListItem
                height: units.gu(7)
                Button {
                    id: customSoundButton
                    text: i18n.tr("Add custom sound")
                    width: parent.width/1.1
                    anchors.centerIn: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("MusicAppPicker.qml"), {alarmSoundPage: _alarmSoundPage})
                    }
                }
            }

            Repeater {
                id: _customAlarmSounds
                objectName: "customAlarmSounds"

                model: customSoundModel

                ListItem {
                    id: _customAlarmSoundDelegate

                    property alias isChecked: _customSoundStatus.checked

                    height: units.gu(7)

                    leadingActions: ListItemActions {
                        actions: [
                            Action {
                                iconName: "delete"
                                onTriggered: {
                                    /*
                                     In case the selected custom alarm sound is deleted by the user, then
                                     set the alarm sound back to the default sound.
                                    */
                                    if (_customAlarmSoundDelegate.isChecked) {
                                        alarmSound.subText = "Alarm clock"

                                        for (var i=0; i<soundModel.count; i++) {
                                            if (soundModel.get(i).fileBaseName === alarmSound.subText)
                                                alarm.sound = soundModel.get(i).fileURL
                                        }

                                        /*
                                         If the oldAlarmSoundName is the deleted custom alarm sound, then
                                         set the oldAlarmSound name & url to the default alarm ringtone as well.
                                        */
                                        if (oldAlarmSoundName === fileName) {
                                            oldAlarmSoundName = alarmSound.subText
                                            oldAlarmSoundUrl = alarm.sound
                                        }
                                    }

                                    fileManagement.deleteFile(standardPath.appDirectory, fileName)
                                }
                            }
                        ]
                    }

                    Label {
                        id: _customSoundName
                        objectName: "customSoundName" + index

                        anchors {
                            left: parent.left
                            leftMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }

                        color: UbuntuColors.midAubergine
                        fontSize: "medium"
                        text: fileBaseName
                    }

                    CheckBox {
                        id: _customSoundStatus
                        objectName: "customSoundStatus" + index

                        anchors {
                            right: parent.right
                            rightMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }

                        checked: alarmSound.subText === _customSoundName.text ? true
                                                                              : false
                        onCheckedChanged: {
                            if (checked) {
                                previewAlarmSound.source = fileURL
                                previewAlarmSound.play()
                                alarmSound.subText = _customSoundName.text
                                alarm.sound = fileURL

                                // Ensures only one alarm sound is selected
                                for(var i=0; i<customSoundModel.count; i++) {
                                    if(_customAlarmSounds.itemAt(i).isChecked &&
                                            i !== index) {
                                        _customAlarmSounds.itemAt(i).isChecked = false
                                    }
                                }

                                // Ensures only one alarm sound is selected
                                for(i=0; i<soundModel.count; i++) {
                                    _alarmSounds.itemAt(i).isChecked = false
                                }
                            }
                        }

                        onClicked: {
                            if (!checked) {
                                checked = true
                            }
                        }
                    }

                    onClicked: {
                        if (!_customSoundStatus.checked) {
                            _customSoundStatus.checked = true
                        }
                    }
                }
            }

            Repeater {
                id: _alarmSounds
                objectName: "alarmSounds"

                model: soundModel

                ListItem {
                    id: _alarmSoundDelegate

                    property alias isChecked: _soundStatus.checked

                    height: units.gu(7)

                    Label {
                        id: _soundName
                        objectName: "soundName" + index

                        anchors {
                            left: parent.left
                            leftMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }

                        color: UbuntuColors.midAubergine
                        fontSize: "medium"
                        text: fileBaseName
                    }

                    CheckBox {
                        id: _soundStatus
                        objectName: "soundStatus" + index

                        anchors {
                            right: parent.right
                            rightMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }

                        checked: alarmSound.subText === _soundName.text ? true
                                                                        : false
                        onCheckedChanged: {
                            if (checked) {
                                previewAlarmSound.source = fileURL
                                previewAlarmSound.play()
                                alarmSound.subText = _soundName.text
                                alarm.sound = fileURL

                                // Ensures only one alarm sound is selected
                                for(var i=0; i<soundModel.count; i++) {
                                    if(_alarmSounds.itemAt(i).isChecked &&
                                            i !== index) {
                                        _alarmSounds.itemAt(i).isChecked = false
                                    }
                                }

                                // Ensures only one alarm sound is selected
                                for(i=0; i<customSoundModel.count; i++) {
                                    _customAlarmSounds.itemAt(i).isChecked = false
                                }
                            }
                        }

                        onClicked: {
                            if (!checked) {
                                checked = true
                            }
                        }
                    }

                    onClicked: {
                        if (!_soundStatus.checked) {
                            _soundStatus.checked = true
                        }
                    }
                }
            }
        }
    }
}
