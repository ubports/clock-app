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

import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

/*
  This component is almost an identical copy of the SDK's subtitled with the
  exception of the font size and color required by the new clock app design.

  #TODO: Revert to using the SDK Subtitled Component when they change the
  design to match the new clock app design.
 */
ListItem.Base {
    id: _subtitledContainer

    // Property to set the main text label
    property alias text: _mainText.text

    // Property to set the subtitle label
    property alias subText: _subText.text
    
    Column {
        id: _labelColumn
        
        anchors.verticalCenter: parent.verticalCenter
        
        Label {
            id: _mainText
            fontSize: "medium"
            color: UbuntuColors.midAubergine
        }
        
        Label {
            id: _subText
            fontSize: "xx-small"
        }
    }
}
