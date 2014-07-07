/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.1
import Qt.labs.folderlistmodel 2.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: _alarmSoundPage

    title: i18n.tr("Sound")
    flickable: _pageFlickable
    visible: false

    // Property to set the alarm sound in the edit alarm page
    property var alarmSound

    FolderListModel {
        id: _soundModel
        showDirs: false
        nameFilters: [ "*.ogg", "*.mp3" ]
        folder: "/usr/share/sounds/ubuntu/ringtones"
    }

    Flickable {
        id: _pageFlickable

        clip: true
        anchors.fill: parent
        contentHeight: _soundModel.count * units.gu(7)

        Column {
            id: _alarmSoundColumn

            anchors.fill: parent

            Repeater {
                id: _alarmSounds

                model: _soundModel

                ListItem.Base {
                    id: _alarmSoundDelegate

                    property alias isChecked: _soundStatus.checked

                    height: units.gu(7)

                    Label {
                        id: _soundName

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }

                        color: UbuntuColors.midAubergine
                        fontSize: "medium"
                        text: fileBaseName
                    }

                    CheckBox {
                        id: _soundStatus

                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        checked: alarmSound.subText === _soundName.text ? true :
                                                                         false
                        onClicked: {
                            if (checked) {
                                alarmSound.subText = _soundName.text

                                // Ensures only one alarm sound is selected
                                for(var i=0; i<_soundModel.count; i++) {
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

    tools: ToolbarItems {
        back: Button {
            action: Action {
                iconName: "back"
                onTriggered: {
                    mainStack.pop()
                }
            }
        }
    }
}
