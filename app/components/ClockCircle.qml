/*
 * Copyright (C) 2014-2015 Canonical Ltd
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
import QtGraphicalEffects 1.0

/*
  Clock Circle with the shadows and background color set depending on the
  position of the circle.

  If used as the outer circle, the shadows are at the top and the background
  has a 30% white shade. On the other hand, if used as the inner clock circle
  then the shadows are at the bottom and the background has a 3% darker shade.

  If used as the inner circle, a textured background image is set as part of
  the new design specs.
 */
Circle {
    id: _innerCircle

    property bool isFoldVisible: true

    color: "#f7f7f7"
    borderWidth: units.dp(1)/*units.gu(0.2)*/
    borderColorTop: "#00000000"
    borderColorBottom: "#6E6E6E"
    borderOpacity: 0.65
    borderGradientPosition: 0.2

    Rectangle {
        visible: isFoldVisible
        anchors.fill: parent
        anchors.margins: borderWidth
        radius: height/2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f7f7f7" }
            GradientStop { position: 0.5; color: "#f7f7f7" }
            GradientStop { position: 0.51; color: "#fdfdfd" }
            GradientStop { position: 1.0; color: "#fdfdfd" }
        }
    }
}
