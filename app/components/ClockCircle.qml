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

import QtQuick 2.2
import Ubuntu.Components 1.1
import QtGraphicalEffects 1.0

/*
  Clock Circle with the shadows and background color set depending on the
  position of the circle.

  If used as the outer circle, the shadows are at the top and the background
  has a 30% white shade. On the other hand, if used as the inner clock circle
  then the shadows are at the bottom and the background has a 3% darker shade.

  The circle position is set by the public property "isOuter". If true, the
  outer circle characteristics are set and vice-versa.
 */
Rectangle {
    id: _innerCircle

    /*
      Property to set if the circle is the outer or the inner circle
     */
    property bool isOuter: false

    height: width
    radius: width / 2
    antialiasing: true
    color: isOuter ? Qt.rgba(1,1,1,0.3) : Qt.rgba(0,0,0,0.03)

    /*
      Rectangle with a gradient background which will be used as a source for
      the opacity mask. It starts of transparent and then gradually turns
      gray at the bottom.

      #TODO: Check with the design team if the gradient positions are correct.
     */
    Rectangle {
        id: _source

        radius: width / 2
        anchors.fill: parent

        antialiasing: true

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: isOuter ? "#6E6E6E" : "Transparent"
            }

            GradientStop {
                position: isOuter ? 0.7 : 0.3
                color: "Transparent"
            }

            GradientStop {
                position: 1.0
                color: isOuter ? "Transparent" : "#6E6E6E"
            }
        }
    }
    
    /*
      Rectangle which will be masked over by the source rectangle. This
      rectangle is required for the border effect which results in the
      shadow.

      #TODO: Check with the design team if the shadow width used is acceptable.
     */
    Rectangle {
        id: _mask

        radius: (width / 2)
        anchors.fill: _source

        antialiasing: true
        color: "Transparent"
        border { width: units.gu(0.2) }
    }
    
    OpacityMask {
        opacity: 0.65
        anchors.fill: _source
        source: ShaderEffectSource {
            sourceItem: _source
            hideSource: true
        }
        maskSource: ShaderEffectSource {
            sourceItem: _mask
            hideSource: true
        }
    }
}
