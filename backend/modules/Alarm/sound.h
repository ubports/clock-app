/*
 * Copyright (C) 2015 Canonical Ltd
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

#ifndef SOUND_H
#define SOUND_H

#include <QObject>
#include <QUrl>

class Sound: public QObject
{
    Q_OBJECT

    // READONLY Property to return the custom alarm sound directory path
    Q_PROPERTY( QString customAlarmSoundDirectory
                READ customAlarmSoundDirectory
                CONSTANT)

public:
    Sound(QObject *parent = 0);

    QString customAlarmSoundDirectory() const;

    Q_INVOKABLE void deleteCustomAlarmSound(const QString &soundName);

    // Function to delete old alarm file sound according to file name from full path.
    // It will able to replace sound alarm with new version
    Q_INVOKABLE void prepareToAddAlarmSound(const QString &soundPath);

    Q_INVOKABLE void createCustomAlarmSoundDirectory();

    Q_INVOKABLE bool isAlarmSoundValid(const QString &soundFileName);
    Q_INVOKABLE bool isAlarmSoundValid(const QUrl &soundUrl);

    Q_INVOKABLE QString getDefaultAlarmSoundPath(const QString &soundFileName) const;

    Q_INVOKABLE QString getSoundName(const QString &soundPath) const;

private:
    QString m_customAlarmDir;
    QString m_defaultAlarmDir;
};

#endif
