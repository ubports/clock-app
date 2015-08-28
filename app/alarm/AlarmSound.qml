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
import Qt.labs.folderlistmodel 2.1

Page {
    id: _alarmSoundPage
    objectName: "alarmSoundPage"

    title: i18n.tr("Sound")
    flickable: _pageFlickable
    visible: false

    // Property used to let pageStack know that this is the alarm sound page
    property bool isAlarmSoundPage: true

    // Property to set the alarm sound in the edit alarm page
    property var alarmSound

    // Property to store the alarm object
    property var alarm

    /*
     Properties to store the previously set alarm sound values to detect
     if the user changed the alarm sound or not
    */
    property url oldAlarmSoundUrl
    property string oldAlarmSoundName

    // Content-hub Import Properties
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

    FolderListModel {
        id: defaultSoundModel
        showDirs: false
        nameFilters: [ "*.ogg", "*.mp3" ]
        folder: "/usr/share/sounds/ubuntu/ringtones"
    }

    FolderListModel {
        id: customSoundModel
        showDirs: false
        folder: alarmSoundHelper.customAlarmSoundDirectory
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
                console.log("[LOG] Original Custom Alarm Sound URL: " + _alarmSoundPage.importItems[0].url)
                alarmSoundHelper.prepareToAddAlarmSound(_alarmSoundPage.importItems[0].url)
                if (_alarmSoundPage.importItems[0].move(alarmSoundHelper.customAlarmSoundDirectory) === true) {
                    // Wait for folder model to update and then select the imported sound
                    waitForCustomSoundModelToUpdate.start()
                }
                console.log("[LOG] Final Custom Alarm Sound URL: " + _alarmSoundPage.importItems[0].url)
            }
        }
    }

    Timer {
        id: waitForCustomSoundModelToUpdate
        interval: 100
        repeat: false
        onTriggered: {
            selectNewlyImportedCustomSound(_alarmSoundPage.importItems[0].url)
        }
    }

    function selectNewlyImportedCustomSound(soundUrl) {
        for (var i=0; i<customSoundModel.count; i++) {
            if (soundUrl === customSoundModel.get(i, "fileURL")) {
                alarmSound.subText = customSoundModel.get(i, "fileBaseName")
                alarm.sound = soundUrl                
                _customAlarmSounds.itemAt(i).isChecked = true
                previewAlarmSound.controlPlayback(soundUrl)
                return
            }
        }
    }

    Connections {
        target: clockApp
        onApplicationStateChanged: {
            previewAlarmSound.stop()
        }
    }

    onVisibleChanged: {
        if (!_alarmSoundPage.visible) {
            previewAlarmSound.stop()
        }
    }

    Audio {
        id: previewAlarmSound
        audioRole: MediaPlayer.alert

        function controlPlayback(fileURL) {
            source = fileURL
            if (playbackState === Audio.StoppedState || playbackState === Audio.PausedState) {
                play()
            } else if (playbackState === Audio.PlayingState) {
                stop()
            }
        }
    }

    AlarmSound {
        id: alarmSoundHelper
    }

    Flickable {
        id: _pageFlickable

        anchors.fill: parent
        contentHeight: defaultSoundModel.count * units.gu(7) +
                       customSoundModel.count * units.gu(7) +
                       customSoundListItem.height +
                       2 * customSoundsHeader.implicitHeight + units.gu(4)

        Column {
            id: _alarmSoundColumn

            anchors.fill: parent

            ListItem {
                id: customSoundListItem
                height: units.gu(7)
                Button {
                    id: customSoundButton
                    text: i18n.tr("Add custom sound")
                    width: parent.width / 1.1
                    anchors.centerIn: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("SoundPeerPicker.qml"), {alarmSoundPage: _alarmSoundPage})
                    }
                }
            }

            ListItem {
                visible: customSoundModel.count !== 0
                height: customSoundsHeader.implicitHeight + units.gu(2)
                Label {
                    id: customSoundsHeader
                    text: i18n.tr("Custom Sounds")
                    font.weight: Font.DemiBold
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }
                }
            }

            Repeater {
                id: _customAlarmSounds
                objectName: "customAlarmSounds"

                model: customSoundModel

                ListItem {
                    id: _customAlarmSoundDelegate
                    objectName: "customAlarmSoundDelegate" + index

                    property bool isChecked: alarmSound.subText === _customSoundName.text ? true
                                                                                          : false

                    height: units.gu(7)

                    leadingActions: ListItemActions {
                        actions: [
                            Action {
                                iconName: "delete"
                                onTriggered: {
                                    previewAlarmSound.stop()

                                    /*
                                     In case the selected custom alarm sound is deleted by the user, then
                                     set the alarm sound back to the default sound.
                                    */
                                    if (_customAlarmSoundDelegate.isChecked) {

                                        /*
                                         If the oldAlarmSoundName is the deleted custom alarm sound, then
                                         set the oldAlarmSound name & url to the default alarm ringtone as well.
                                        */
                                        if (oldAlarmSoundName === fileBaseName) {
                                            alarmSound.subText = alarmSound.defaultAlarmSound
                                            oldAlarmSoundName = alarmSound.defaultAlarmSound
                                            for (var i=0; i<defaultSoundModel.count; i++) {
                                                if (defaultSoundModel.get(i, "fileBaseName") === alarmSound.subText) {
                                                    alarm.sound = defaultSoundModel.get(i, "fileURL")
                                                    oldAlarmSoundUrl = alarm.sound                                                    
                                                    _alarmSounds.itemAt(i).isChecked = true
                                                    previewAlarmSound.controlPlayback(defaultSoundModel.get(i, "fileURL"))
                                                }
                                            }
                                        }

                                        else {
                                            alarmSound.subText = oldAlarmSoundName
                                            alarm.sound = oldAlarmSoundUrl
                                            previewAlarmSound.controlPlayback(alarm.sound)

                                            for (var j=0; j<defaultSoundModel.count; j++) {
                                                if (defaultSoundModel.get(j, "fileBaseName") === alarmSound.subText) {
                                                    _alarmSounds.itemAt(j).isChecked = true
                                                }
                                            }

                                            for (j=0; j<customSoundModel.count; j++) {
                                                if (customSoundModel.get(j, "fileBaseName") === alarmSound.subText) {
                                                    _customAlarmSounds.itemAt(j).isChecked = true
                                                }
                                            }
                                        }
                                    }

                                    alarmSoundHelper.deleteCustomAlarmSound(fileName)
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
                            right: tickIcon.left
                            rightMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }

                        elide: Text.ElideRight
                        color: UbuntuColors.midAubergine
                        fontSize: "medium"
                        text: fileBaseName
                    }

                    Icon {
                        id: tickIcon
                        width: units.gu(2)
                        height: width
                        name: "tick"
                        visible: _customAlarmSoundDelegate.isChecked

                        anchors {
                            right: parent.right
                            rightMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    onIsCheckedChanged: {
                        if (isChecked) {
                            alarmSound.subText = _customSoundName.text
                            alarm.sound = fileURL

                            // Ensures only one custom alarm sound is selected
                            for(var i=0; i<customSoundModel.count; i++) {
                                if(_customAlarmSounds.itemAt(i).isChecked && i !== index) {
                                    _customAlarmSounds.itemAt(i).isChecked = false
                                }
                            }

                            // Uncheck all the default alarm sounds
                            for(i=0; i<defaultSoundModel.count; i++) {
                                _alarmSounds.itemAt(i).isChecked = false
                            }
                        }
                    }

                    onClicked: {
                        if (!_customAlarmSoundDelegate.isChecked) {
                            _customAlarmSoundDelegate.isChecked = true
                        }
                        previewAlarmSound.controlPlayback(fileURL)
                    }
                }
            }

            ListItem {
                visible: customSoundModel.count !== 0
                height: defaultSoundsHeader.implicitHeight + units.gu(2)
                Label {
                    id: defaultSoundsHeader
                    text: i18n.tr("Default Sounds")
                    font.weight: Font.DemiBold
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }
                }
            }

            Repeater {
                id: _alarmSounds
                objectName: "alarmSounds"

                model: defaultSoundModel

                ListItem {
                    id: _alarmSoundDelegate
                    objectName: "alarmSoundDelegate" + index

                    property bool isChecked: alarmSound.subText === _soundName.text ? true
                                                                                    : false

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

                    Icon {
                        width: units.gu(2)
                        height: width
                        name: "tick"
                        visible: _alarmSoundDelegate.isChecked

                        anchors {
                            right: parent.right
                            rightMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    onIsCheckedChanged: {
                        if (isChecked) {
                            alarmSound.subText = _soundName.text
                            alarm.sound = fileURL

                            // Ensures only one alarm sound is selected
                            for(var i=0; i<defaultSoundModel.count; i++) {
                                if(_alarmSounds.itemAt(i).isChecked &&
                                        i !== index) {
                                    _alarmSounds.itemAt(i).isChecked = false
                                }
                            }

                            // Uncheck all the custom alarm sounds
                            for(i=0; i<customSoundModel.count; i++) {
                                _customAlarmSounds.itemAt(i).isChecked = false
                            }
                        }
                    }

                    onClicked: {
                        if (!_alarmSoundDelegate.isChecked) {
                            _alarmSoundDelegate.isChecked = true
                        }
                        previewAlarmSound.controlPlayback(fileURL)
                    }
                }
            }
        }
    }
}
