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
import Alarm 1.0
import QtMultimedia 5.0
import Ubuntu.Content 1.3
import Ubuntu.Components 1.3
import Qt.labs.folderlistmodel 2.1

Page {
    id: _alarmSoundPage
    objectName: "alarmSoundPage"

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

    header: PageHeader {
        title: i18n.tr("Sound")
        flickable: _pageFlickable
        leadingActionBar.actions: [
            Action {
                iconName: "back"
                onTriggered: {
                    // Restore alarm sound to old values (url, name) if the back button is pressed
                    alarm.sound = oldAlarmSoundUrl
                    alarmSound.subText = oldAlarmSoundName
                    pop()
                }
            }
        ]
        trailingActionBar.actions: [
            Action {
                id: saveAction
                objectName: "saveAction"
                iconName: "ok"
                enabled: oldAlarmSoundUrl !== alarm.sound
                onTriggered: {
                    pop()
                }
            }
        ]
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
        target: rootWindow
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
        contentHeight: _alarmSoundColumn.height

        Column {
            id: _alarmSoundColumn

            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
            }

            ListItem {
                height: customSoundsHeader.implicitHeight + units.gu(2)
                Label {
                    id: customSoundsHeader
                    text: i18n.tr("Custom alarm sounds")
                    font.weight: Font.DemiBold
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem {
                id: customSoundListItem
                height: units.gu(7)
                Button {
                    id: customSoundButton
                    text: i18n.tr("Add sound")
                    width: parent.width / 1.1
                    anchors.centerIn: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("SoundPeerPicker.qml"), {alarmSoundPage: _alarmSoundPage})
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

                    property bool isChecked: alarmSound.subText === _customSoundName.title.text ? true
                                                                                                : false

                    height: _customSoundName.height + divider.height

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

                    ListItemLayout {
                        id: _customSoundName
                        objectName: "customSoundName" + index

                        title.text: fileBaseName

                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            height: width
                            name: "media-playback-pause"
                            visible: _customAlarmSoundDelegate.isChecked &&
                                     previewAlarmSound.playbackState === Audio.PlayingState
                        }

                        Icon {
                            id: tickIcon
                            SlotsLayout.position: SlotsLayout.Last
                            opacity: _customAlarmSoundDelegate.isChecked ? 1 : 0
                            width: units.gu(2)
                            height: width
                            name: "tick"
                        }
                    }

                    onIsCheckedChanged: {
                        if (isChecked) {
                            alarmSound.subText = _customSoundName.title.text
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
                height: defaultSoundsHeader.implicitHeight + units.gu(2)
                Label {
                    id: defaultSoundsHeader
                    text: i18n.tr("Default alarm sounds")
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

                    property bool isChecked: alarmSound.subText === _soundName.title.text ? true
                                                                                          : false

                    height: _soundName.height + divider.height

                    ListItemLayout {
                        id: _soundName

                        title.text: fileBaseName
                        title.objectName: "soundName"

                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            height: width
                            name: "media-playback-pause"
                            visible: _alarmSoundDelegate.isChecked &&
                                     previewAlarmSound.playbackState === Audio.PlayingState
                        }

                        Icon {
                            SlotsLayout.position: SlotsLayout.Last
                            opacity: _alarmSoundDelegate.isChecked ? 1 : 0
                            width: units.gu(2)
                            height: width
                            name: "tick"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    onIsCheckedChanged: {
                        if (isChecked) {
                            alarmSound.subText = _soundName.title.text
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
