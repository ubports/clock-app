/*
 * Copyright (C) 2016 Canonical Ltd
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
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3

Page {
    id: picker

    // #TRANSLATORS: This is the page title. Please keep the translation length to 3 words if possible
    title: i18n.tr("Add sound from")

    property var alarmSoundPage

    ContentPeerPicker {
        id: peerPicker
        handler: ContentHandler.Source
        contentType: ContentType.Music
        showTitle: false

        onPeerSelected: {
            peer.selectionType = ContentTransfer.Single
            alarmSoundPage.activeTransfer = peer.request()
            pageStack.pop()
        }
    }
}
