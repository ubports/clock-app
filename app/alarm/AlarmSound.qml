/*
 * Copyright (C) 2014 Canonical Ltd
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

import QtQuick 2.0
import QtMultimedia 5.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: _alarmSoundPage

    title: i18n.tr("Sound")
    flickable: _pageFlickable
    visible: false

    // Property to set the alarm sound in the edit alarm page
    property var alarmSound

    // Property to store the alarm object
    property var alarm

    // Property to set the alarm sound model in the edit alarm page
    property var soundModel

    head.backAction: Action {
        iconName: "back"
        onTriggered: {
            pop()
        }
    }

    Audio {
        id: previewAlarmSound
    }

    Flickable {
        id: _pageFlickable

        clip: true
        anchors.fill: parent
        contentHeight: soundModel.count * units.gu(7)

        Column {
            id: _alarmSoundColumn

            anchors.fill: parent

            Repeater {
                id: _alarmSounds
                objectName: "alarmSounds"

                model: soundModel

                ListItem.Standard {
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

                    control: CheckBox {
                        id: _soundStatus
                        objectName: "soundStatus" + index

                        checked: alarmSound.subText === _soundName.text ? true
                                                                        : false
                        onClicked: {
                            if (checked) {
//                                previewAlarmSound.source = fileURL
//                                previewAlarmSound.play()

                                alarmSound.subText = _soundName.text
                                alarm.sound = fileURL

                                // Ensures only one alarm sound is selected
                                for(var i=0; i<soundModel.count; i++) {
                                    if(_alarmSounds.itemAt(i).isChecked &&
                                            i !== index) {
                                        _alarmSounds.itemAt(i).isChecked = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
